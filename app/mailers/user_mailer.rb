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
  
  def top_strains(user)
    sendgrid_category 'Top Strains'
    @user = user
    @strains = Strain.where(:id => @user.latest_picked_strain_ids)
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Top strains")
  end
end