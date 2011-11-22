require 'spec_helper'
support_require 'vcr'
support_require 'redis'

describe "ClubCreations" do
  let(:queue_list) { ['critical','high','medium','low'] }
  let(:login_button) { "Login" }
  
  before(:each) do
    @admin_user = Factory(:user)
    @admin_user.roles = ['member','admin']
    @regular_user = Factory(:user, :email => 'reg@example.com')
    @regular_user.save_without_session_maintenance
  end
  
  after(:all) do
    clear_resque(queue_list)
  end
  
  it "both user should be able to log in" do
    visit login_path
    fill_in 'user_session_email', :with => @regular_user.email
    fill_in 'user_session_password', :with => 'password'
    click_button login_button
    page.should have_content('Logged in')
    
    visit root_path
    click_link 'Logout'
    
    visit login_path
    fill_in 'user_session_email', :with => @admin_user.email
    fill_in 'user_session_password', :with => 'password'
    click_button login_button
    page.should have_content('Logged in')
  end
  
  describe 'on failure' do
    before(:each) do
      visit login_path
      fill_in 'user_session_email', :with => @regular_user.email
      fill_in 'user_session_password', :with => 'password'
      click_button login_button
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
      click_button login_button
      
      visit new_club_path
      fill_in 'club_email', :with => 'club@gmail.com'
      fill_in 'club_name', :with => 'MJ club'
      fill_in 'club_address', :with => '346 Laurel Avenue, CA 91006'
    end
    
    it "should be able to create new club", :vcr, record: :new_episodes do
      lambda do
        click_button 'Create Club'
      end.should change(Club,:count).from(0).to(1)
    end
    
    it 'should complete Geocode job, and return longitude and latitude values', :vcr, record: :new_episodes do
      clear_resque(queue_list)
      
      click_button 'Create Club'
      
      jobs_pending.should eq(1)
      perform_all_pending_jobs
      
      club = Club.last
      club.longitude.round(2).should eq(-118.02)
      club.latitude.round(2).should eq(34.15)
    end
  end
end
