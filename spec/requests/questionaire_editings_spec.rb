require 'spec_helper'

describe "QuestionaireEditings" do
  before(:each) do
    Questionaire.create!
    
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
    
    it 'viewing questionaire index page' do
      visit questionaires_path
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
    
    it 'on viewing questionaire index page and have link to edit questionaire' do
      visit questionaires_path
      current_path.should eq(questionaires_path)
      page.should have_link('Edit questionaire', :href => edit_questionaire_path(Questionaire.first))
    end
  end
end
