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
end