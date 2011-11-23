class UserMailer < ActionMailer::Base
  include SendGrid
  sendgrid_category :use_subject_lines
  sendgrid_enable   :ganalytics, :opentrack, :clicktrack
  
  default :from => "cannanerds@gmail.com"
  
  def registration_confirmation(user)
    sendgrid_category 'Registration'
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "User account verification from Cannaerd")
  end
end