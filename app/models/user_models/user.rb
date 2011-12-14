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
#  perishable_token   :string(255)     default("temptoken"), not null
#  current_login_ip   :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  roles_mask         :integer         default(1)
#  zipcode            :string(255)
#  top_strains        :text
#  tag_list           :text
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
    
    c.perishable_token_valid_for = 2.weeks
    c.disable_perishable_token_maintenance = true
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
  
  has_many :quizzes, :dependent => :destroy
  has_many :notifications, :dependent => :destroy
  has_many :strain_histories, :dependent => :destroy
  
  #before_create :reset_perishable_token
  
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
    self.reset_perishable_token!
    self.roles = ['member']
  end
  
  def unread_notification_count
    self.notifications.all_unread.count
  end
  
  def latest_answers
    self.quizzes.most_recent.answer_ids
  end
  
  def latest_picked_strain_ids
    eval(strain_histories.created_order.first.list).map{|i|i[:strain_id]}
  end
  
  def update_tag_list!
    answer_ids = self.latest_answers
    answers = Answer.where(:id => answer_ids)
    tag_list = answers.all_tag_counts.map(&:name).join(',')
    self.tag_list = tag_list
    save
    
    self.tag_list
  end
  
  def init_user
    self.reset_perishable_token!
    
    send_registration_confirmation
    update_top_strain
  end
  
  def check_and_send_top_strains
    if top_strains_valid?
      num_of_strains = 5
      pick_strains!(num_of_strains)
      send_top_strain
    else
      self.notifications.create(:content => 'Results from quiz are vague, retake test')
    end
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
  
  ################# private functions ###################
  
  private
    def send_registration_confirmation
      Resque::enqueue(SendUserMail, :registration_confirmation, self.id)
    end
    
    def update_top_strain
      Resque::enqueue(UpdateTopStrain, self.id)
    end
    
    def send_top_strain
      #Resque::enqueue(SendUserMail, :registration_confirmation, self.id)
      Resque::enqueue(SendUserMail, :top_strains, self.id)
    end
    
    def top_strains_valid?
      unless self.top_strains.nil?
        top_strain_array = eval(self.top_strains)
        top_strain_array.last[:rank] > 2 && top_strain_array.count >= 10
      else
        false
      end
    end
    
    def pick_strains!(num_of_strains)
      top_strain_array = eval(self.top_strains)
      index_list = (0..top_strain_array.count-1).to_a.sort{ rand() - 0.5 }[0..num_of_strains-1]
      self.strain_histories.create(:list => top_strain_array.select.with_index {|item,index| index_list.include?(index) }.to_s)
      save
    end
    
    # def reset_perishable_token
    #   self.reset_perishable_token!
    # end
end
