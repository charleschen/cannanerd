# == Schema Information
#
# Table name: quiziations
#
#  id                 :integer         not null, primary key
#  quiz_id            :integer
#  question_id        :integer
#  selected_answer_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#

require 'spec_helper'

describe Quiziation do
  pending "add some examples to (or delete) #{__FILE__}"
end
