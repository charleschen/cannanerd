require 'spec_helper'

describe UpdateTopStrain do
  let(:user) { Factory(:user) }
  let(:tag_list){
    [['indica','strain'],
                ['sativa','strain'],
                ['ADD','medical'],
                ['ADHD','medical'],
                ['cancer','medical'],
                ['PTSD','medical'],
                ['Aroused','effect'],
                ['giggly','effect'],
                ['sweet','flavor'],
                ['spicy','flavor'],
                ['hungry','effect']]}
                
  before(:each) do
    questionnaire = Questionnaire.create()
  end
  
  it 'should respond to :peform' do
    UpdateTopStrain.should respond_to(:perform)
  end
    
  it 'should require a user_id' do
    lambda { UpdateTopStrain.perform }.should raise_error
  end
  
  it 'should complete perform without error' do
    UpdateTopStrain.perform(user.id)
  end
  
  it 'should give the right top strain' do
    # @user = user
    # UpdateTopStrain.perform(@user.id)
    # 
    # @user.top_strain_data.should eq(['11','10','9','8','7'])
    # 
    # 5.times do |count|
    #   @user.top_strains.should include(Strain.find_by_id_str((count+)))
    # end
  end
  
end