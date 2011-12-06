# == Schema Information
#
# Table name: quizzes
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Quiz < ActiveRecord::Base
  #validates :user_id, :presence => true
  attr_writer :current_page
  
  belongs_to :user
  
  has_many :quiziations, :dependent => :destroy, :foreign_key => 'quiz_id'
  has_many :questions, :through => :quiziations, :source => :question

  accepts_nested_attributes_for :quiziations
  
  scope :recently_updated, :order => 'updated_at DESC'
  
  def self.most_recent
    recently_updated.first
  end
  
  
  def current_page
    @current_page ||= 1
  end
  
  def total_pages
    ((questions.count+0.0)/questions.first.questionnaire.per_page).ceil
  end
  
  def percentage_complete
    #((questions.count+0.0)/questions.first.questionnaire.per_page).ceil
    if first_page?
      0
    else
      ((current_page-1.0)/(total_pages-1)).round(2)*100
    end
  end
  
  def first_page?
    @current_page == 1
  end
  
  def last_page?
    if questions.any?
      @current_page == ((questions.count+0.0)/questions.first.questionnaire.per_page).ceil 
      #questions.paginate(:page => 1, :per_page => questions.first.questionnaire.per_page).total_pages
    else
      1
    end
  end
  
  def next_page
    @current_page = @current_page + 1 unless last_page?
    @current_page
  end
  
  def prev_page
    @current_page = @current_page - 1 unless first_page?
    @current_page
  end
  
  def answer_ids
    answer_ids = []
    quiziations.each do |quiziation|
      eval(quiziation.answers_hash).each do |key,val|
        answer_ids << key.to_s.split('answer_')[1].to_i
      end
    end
    answer_ids
  end
end
