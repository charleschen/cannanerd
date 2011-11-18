class Geocode
  #extend HerokuAutoScaler::AutoScaling
  @queue = :high
  
  def self.perform(club_id)
    self.new.send(:perform,club_id)
  end
  
  def perform(club_id)
    club = Club.find(club_id)
    club.geocode
    club.save
  end
end