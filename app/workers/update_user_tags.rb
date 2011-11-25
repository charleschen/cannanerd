class UpdateUserTags
  extend HerokuAutoScaler
  @queue = :medium
  
  def self.perform(user_id)
    self.new.send(:perform,user_id)
  end
  
  def perform(user_id)
    user = User.find(user_id)
    answer_ids = user.latest_answers
    answers = Answer.where(:id => answer_ids)
    tag_list = answers.all_tag_counts.map(&:name).join(',')
    user.update_attribute(:tag_list,tag_list)
  end
  
end