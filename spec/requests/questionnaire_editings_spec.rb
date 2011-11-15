require 'spec_helper'

describe "QuestionnaireEditings" do
  before(:each) do
    Questionnaire.create!
    
    @admin_user = Factory(:user)
    @admin_user.roles = ['member','admin']
    @regular_user = Factory(:user, :email => 'reg@example.com')
  end
  
  describe 'failure' do
    before(:each) do
      visit login_path
      fill_in 'user_session_email', :with => @regular_user.email
      fill_in 'user_session_password', :with => 'password'
      click_button 'Create User session'
    end
    
    it 'viewing questionnaire index page' do
      visit questionnaires_path
      page.should have_content('do not have access')
      current_path.should eq(root_path)
    end
  end
  
  describe 'success' do
    before(:each) do
      visit login_path
      fill_in 'user_session_email', :with => @admin_user.email
      fill_in 'user_session_password', :with => 'password'
      click_button 'Create User session'
    end
    
    it 'on viewing questionnaire index page and have link to edit questionnaire' do
      visit questionnaires_path
      current_path.should eq(questionnaires_path)
      page.should have_button('Edit questionnaire')
    end
  end
end
