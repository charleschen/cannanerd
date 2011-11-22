# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)     not null
#  email              :string(255)     not null
#  crypted_password   :string(255)     not null
#  password_salt      :string(255)     not null
#  persistence_token  :string(255)     not null
#  login_count        :integer         default(0), not null
#  failed_login_count :integer         default(0), not null
#  perishable_token   :string(255)     not null
#  current_login_ip   :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  roles_mask         :integer         default(1)
#  zipcode            :string(255)
#

require 'authlogic'
require 'likeable'

class User < ActiveRecord::Base
  include Likeable::UserMethods
  acts_as_authentic do |c|
    #c.validates_format_of_login_field_options(:with => /\A\w[\w\.+\-_@' ]+$/)
    #c.find_by_login_method = :find_by_email
    c.session_class = UserSession
    c.login_field = :email
    c.validate_email_field = false
    c.validate_login_field = false
    c.maintain_sessions = false
  end
  
  email_name_regex  = '[A-Z0-9_\.%\+\-\']+'
  domain_head_regex = '(?:[A-Z0-9\-]+\.)+'
  domain_tld_regex  = '(?:[A-Z]{2,4}|museum|travel)'
  email_regex = /^#{email_name_regex}@#{domain_head_regex}#{domain_tld_regex}$/i
  zipcode_regex = /[0-9]{5}/
  
  validates :email, :presence => true, 
                    :uniqueness => { :case_sensitive => false},
                    :format => { :with => email_regex}
  validates :name, :presence => true
  validates :zipcode, :presence => true, :format => {:with => zipcode_regex }
  
  attr_accessible :email, :name, :password, :password_confirmation, :zipcode
  
  ROLES = %w[unverified_member member admin]
  
  has_many :related_tags, :dependent => :destroy, :foreign_key => 'user_id'
  has_many :tags, :through => :related_tags, :source => :tag
  
  has_many :quizzes, :dependent => :destroy
  
  
  
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
  
  def has_role?(role)
    roles.include? role
  end
  
  def verify!
    self.roles = ['member']
  end
  
  def init_user
    send_registration_confirmation
    update_user_tags
  end
  
  ####################  Answership Functions  ####################  
  
  def has_answered?(answer)
    !self.answerships.find_by_answer_id(answer).nil?
  end
  
  def submit!(answer)
    self.answerships.create(:answer_id => answer.id)
  end
  
  def unsubmit!(answer)
    self.answerships.find_by_answer_id(answer).destroy
  end
  
  ####################  Email Functions  ####################  
  private
    def send_registration_confirmation
      Resque::enqueue(SendUserMail, :registration_confirmation, self.id)
    end
    
    def update_user_tags
      Resque::enqueue(UpdateUserTags, self.id)
    end
end
