# == Schema Information
#
# Table name: clubs
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  crypted_password   :string(255)     not null
#  password_salt      :string(255)     not null
#  persistence_token  :string(255)     not null
#  login_count        :integer         default(0), not null
#  failed_login_count :integer         default(0), not null
#  perishable_token   :string(255)     not null
#  verified           :boolean
#  lat                :float
#  lng                :float
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

require 'authlogic'

class Club < ActiveRecord::Base
  acts_as_authentic do |c|
    #c.validates_format_of_login_field_options(:with => /\A\w[\w\.+\-_@' ]+$/)
    #c.find_by_login_method = :find_by_email
    c.session_class = ClubSession
    c.login_field = :email
    c.validate_email_field = false
    c.validate_login_field = false
  end
  
  email_name_regex  = '[A-Z0-9_\.%\+\-\']+'
  domain_head_regex = '(?:[A-Z0-9\-]+\.)+'
  domain_tld_regex  = '(?:[A-Z]{2,4}|museum|travel)'
  email_regex = /^#{email_name_regex}@#{domain_head_regex}#{domain_tld_regex}$/i
  
  validates :name,  :presence => true,
                    :uniqueness => {:case_sensitive => false}
                    
  validates :email, :uniqueness => {:case_sensitive => false},
                    :format => email_regex
                    
  attr_accessible :email, :name, :password, :password_confirmation
  
  def verify!
    self.verified = true
    save
  end
end
