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
    
    it "should visit edit questionaire path and edit/remove questions" do
      create_questionaire_data
      
      visit questionnaires_path
      page.click_button 'Edit questionnaire'
      current_path.should eq(edit_questionnaire_path(Questionnaire.first))
      
      page.should have_checked_field('questionnaire[questions_attributes][0][multichoice]')
      page.should have_no_checked_field('questionnaire[questions_attributes][1][multichoice]')
      page.should have_checked_field('questionnaire[questions_attributes][2][multichoice]')
      
      fill_in 'questionnaire[questions_attributes][0][content]', :with => 'right?'      
      # fill_in 'questionnaire[questions_attributes][0][answers_attributes][0][content]', :with => 'nowerd'
      # fill_in 'questionnaire[questions_attributes][0][answers_attributes][1][content]', :with => 'yeswerd'
      
      click_button 'delete_questionnaire[questions_attributes][0]'
      
      click_button 'Update Questionnaire'
      current_path.should eq(questionnaires_path)
      page.should have_content('Questionnaire updated')
      
      click_button 'Edit questionnaire'
      page.should have_selector('textarea#questionnaire_questions_attributes_0_content',:text => 'right?')
    end
  end
end
