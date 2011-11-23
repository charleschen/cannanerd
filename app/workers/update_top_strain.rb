class UpdateTopStrain
  extend HerokuAutoScaler
  
  def self.perform(user_id)
    User.find(user_id)
  end
end