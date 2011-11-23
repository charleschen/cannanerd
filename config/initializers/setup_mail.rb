require 'development_mail_interceptor'


# ActionMailer::Base.smtp_settings = {
#   :address              => "smtp.gmail.com",
#   :port                 => 587,
#   :domain               => "gmail.com",
#   :user_name            => ENV["EMAIL_USERNAME"],
#   :password             => ENV["EMAIL_PASSWORD"],
#   :authentication       => "plain",
#   :enable_starttls_auto => true
# }

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.sendgrid.net",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => ENV["EMAIL_USERNAME"],
  :password             => ENV["EMAIL_PASSWORD"],
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = ENV["DOMAIN_URL"]
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?


# $ heroku config:add GMAIL_USER=email@email.com 
#     $ heroku config:add GMAIL_PASSWORD=password 
#     $ heroku config:add MY_DOMAIN=pablocantero.com