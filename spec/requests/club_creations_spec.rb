require 'spec_helper'

describe "ClubCreations" do
  before(:each) do
    @admin_user = Factory(:user)
    @admin_user.roles = ['member','admin']
    @regular_user = Factory(:user, :email => 'reg@example.com')
    @regular_user.save_without_session_maintenance
  end
  
  it "both user should be able to log in" do
    visit login_path
    fill_in 'user_session_email', :with => @regular_user.email
    fill_in 'user_session_password', :with => 'password'
    click_button 'Create User session'
    page.should have_content('Logged in')
    
    visit root_path
    click_link 'Logout'
    
    visit login_path
    fill_in 'user_session_email', :with => @admin_user.email
    fill_in 'user_session_password', :with => 'password'
    click_button 'Create User session'
    page.should have_content('Logged in')
  end
  
  describe 'on failure' do
    before(:each) do
      visit login_path
      fill_in 'user_session_email', :with => @regular_user.email
      fill_in 'user_session_password', :with => 'password'
      click_button 'Create User session'
    end
    
    it 'regular user cannot create clubs' do
      visit new_club_path
      page.should have_content('do not have access')
      current_path.should eq(root_path)
    end
  end
  
  describe 'on success' do
    before(:each) do
      visit login_path
      fill_in 'user_session_email', :with => @admin_user.email
      fill_in 'user_session_password', :with => 'password'
      click_button 'Create User session'
    end
    
    it "should be able to create new club" do
      visit new_club_path
      fill_in 'club_email', :with => 'club@gmail.com'
      fill_in 'club_name', :with => 'MJ club'
      
      lambda do
        click_button 'Create Club'
      end.should change(Club,:count).by(1)
    end
  end
end
