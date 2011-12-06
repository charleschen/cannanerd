class UpdateTopStrain
  extend HerokuAutoScaler
  @queue = :high
  
  MAX_SEARCH_RADIUS = 25
  MINIMUM_STRAIN_COUNT = 10
  
  def self.perform(user_id)
    with_logging do
      self.new.send(:perform,user_id)
    end
  end
  
  def self.with_logging(&block)
    time = Benchmark.ms do
      yield block
    end
    
    #puts("completed in (%.1fms)" % [time])
  end
  
  def perform(user_id)    
    user = User.find(user_id)
    
    user_tag_list = ActsAsTaggableOn::TagList.from(user.update_tag_list!)
    user_tag_list = nil if user_tag_list.count == 0
    user_tags = ActsAsTaggableOn::Tag.named_any(user_tag_list)  # gets all Tag instances from tag_list
    
    search_radius = 5
    strain_list = []
    while(strain_list.count < MINIMUM_STRAIN_COUNT && search_radius <= MAX_SEARCH_RADIUS)
      club_ids = Club.near(user.zipcode, search_radius).map(&:id)
      strain_list = Strain.available_from(club_ids)
      search_radius += 5
    end
    
    strain_hash = Hash.new(0)
    
    user_tags.each do |tag|
      strain_ids_with_tag = Strain.tagged_with(tag.name).map(&:id)
      strains_with_tag = strain_list.where(:id => strain_ids_with_tag)
      
      strains_with_tag.each do |strain|
        #strain_hash[strain.id_str.to_sym] ||= 0
        #strain_hash[strain.id_str.to_sym] += 1
        #strain_hash["strain_#{strain.id}".to_sym] ||= 0
        strain_hash["strain_#{strain.id}".to_sym] += 1
      end
    end
    # [{:strain_id => , :rank => }]
    #sorted_strain_ids = strain_hash.sort {|a,b| b[1] <=> a[1] }.map{|h| [h[0].to_s.split('strain_').last.to_i,h[1].to_i] }
    sorted_strain_ids = strain_hash.sort {|a,b| b[1] <=> a[1] }.map{|h| {:strain_id => h[0].to_s.split('strain_').last.to_i, :rank => h[1].to_i} }
    user.update_attribute(:top_strains, sorted_strain_ids[0..14].to_s)  # returns ids of top 15 strains
  end
  
end