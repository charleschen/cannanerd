# == Schema Information
#
# Table name: clubs
#
#  id                 :integer         not null, primary key
#  email              :string(255)     not null
#  name               :string(255)     not null
#  crypted_password   :string(255)     not null
#  password_salt      :string(255)     not null
#  persistence_token  :string(255)     not null
#  login_count        :integer         default(0), not null
#  failed_login_count :integer         default(0), not null
#  perishable_token   :string(255)     not null
#  latitude           :float
#  longitude          :float
#  current_login_ip   :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  roles_mask         :integer         default(1)
#  address            :string(255)
#

require 'authlogic'
require 'geocoder'

class Club < ActiveRecord::Base
  email_name_regex  = '[A-Z0-9_\.%\+\-\']+'
  domain_head_regex = '(?:[A-Z0-9\-]+\.)+'
  domain_tld_regex  = '(?:[A-Z]{2,4}|museum|travel)'
  email_regex = /^#{email_name_regex}@#{domain_head_regex}#{domain_tld_regex}$/i
  
  validates :name,  :presence => true,
                    :uniqueness => {:case_sensitive => false}
  validates :email, :uniqueness => {:case_sensitive => false},
                    :format => email_regex
  validates :address, :presence => true
  
  geocoded_by :address
  acts_as_authentic do |c|
    #c.validates_format_of_login_field_options(:with => /\A\w[\w\.+\-_@' ]+$/)
    #c.find_by_login_method = :find_by_email
    c.session_class = ClubSession
    c.login_field = :email
    c.validate_email_field = false
    c.validate_login_field = false
    c.maintain_sessions = false
  end
  

  

                    
  attr_accessible :email, :name, :password, :password_confirmation, :address
  
  after_save :get_geocode, :if => :address_changed?
  
  ROLES = %w[unregistered registered]
  
  def roles
    ROLES.reject {|role| ((self.roles_mask || 0) & 2**ROLES.index(role)).zero? }
  end
  
  def roles=(roles)
    self.roles_mask = (roles & ROLES).map {|role| 2**ROLES.index(role)}.sum
    save!
  end
  
  def role_symbols
    roles.map(&:to_sym)
  end
  
  def register!
    self.roles = ['registered']
  end
  
  private
    def get_geocode
      Resque::enqueue(Geocode,self.id)
    end
end
