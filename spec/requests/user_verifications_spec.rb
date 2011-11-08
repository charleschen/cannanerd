require 'spec_helper'

describe "UserVerifications" do
  before(:each) do
    @user = Factory.build(:user)
    @user.save_without_session_maintenance
  end
  
  it "verfies user" do
    visit user_verification_path(@user.perishable_token)
    @user.reload
    #@user.should be_verified
    @user.should have_role('member')
    current_path.should eq(root_path)
  end
  
  it "should reset perishable_token" do
    old_perishable_token = String.new(@user.perishable_token)
    visit user_verification_path(@user.perishable_token)
    @user.reload
    @user.perishable_token.should_not eq(old_perishable_token)
  end
end
