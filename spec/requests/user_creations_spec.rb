require 'spec_helper'

describe "UserCreations" do
  before(:each) do
    @attr = { :username => "Charles Chen",
              :email    => "charleschen@gmail.com",
              :password => 'password'
            }
  end
  
  it "should have a link to sign up" do
    visit root_path
    page.should have_link("Sign up", :href => new_user_path)
  end
  
  it "should have a submit button for signing up" do
    visit root_path
    click_link 'Sign up'
    page.should have_button('Create User')
  end
  
  describe 'on failure' do
    before(:each) do
      visit root_path
      click_link 'Sign up'
    end
    
    it "should dispay validation errors with no fields filled in" do
      click_button 'Create User'
      page.should have_selector('div', :id=>'error_explanation')
    end
    
    it "should not create new user without same password" do
      fill_in "user_username",  :with => @attr[:username]
      fill_in "user_email",     :with => @attr[:email]
      fill_in "user_password",       :with => @attr[:password]
      fill_in "user_password_confirmation",       :with => 'werd'
      
      lambda do
        click_button 'Create User'
      end.should_not change(User,:count)
      last_email.should be_nil
    end
  end
  
  describe 'on success' do
    before(:each) do
      visit root_path
      click_link 'Sign up'
      
      fill_in "user_username",              :with => @attr[:username]
      fill_in "user_email",                 :with => @attr[:email]
      fill_in "user_password",              :with => @attr[:password]
      fill_in "user_password_confirmation", :with => @attr[:password]
    end
    
    it "should create user with the right info filled in" do
      lambda do
        click_button 'Create User'
      end.should change(User,:count).by(1)
      page.should have_content("success")
    end
    
    it "should email user with verification details" do
      click_button 'Create User'
      user = User.find_by_username(@attr[:username])
      last_email.to.should include(user.email)
    end
  end
  
end
