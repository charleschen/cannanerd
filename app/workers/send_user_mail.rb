class SendUserMail
  extend HerokuAutoScaler
  @queue = :critical
  
  def self.perform(method,user_id)
    self.new.send(method,user_id)
  end
  
  def registration_confirmation(user_id)
    user = User.find(user_id)
    UserMailer.registration_confirmation(user).deliver
  end
  
  def top_strains(user_id)
    user = User.find(user_id)
    UserMailer.top_strains(user).deliver
    
    user.notifications.create(:content => 'Top strains has been emailed to you!')
  end
end