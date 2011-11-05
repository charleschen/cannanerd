class UserMailer < ActionMailer::Base
  default :from => "cannanerd08@gmail.com"
  def registration_confirmation(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "User account verification from Cannaerd")
  end
end