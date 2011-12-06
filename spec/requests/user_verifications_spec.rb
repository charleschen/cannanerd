require 'spec_helper'
support_require 'redis'
support_require 'mailer_macros'

describe "UserVerifications" do
  before(:each) do
    @user = Factory.build(:user)
    @user.save_without_session_maintenance
  end
  let(:top_strain_email_subject){ 'Top strains' }
  
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
  
  describe 'sending top strains' do
    let(:valid_top_strains){[ { :strain_id => 3,:rank => 6 },
                              { :strain_id => 4,:rank => 5 },
                              { :strain_id => 2,:rank => 5 },
                              { :strain_id => 6,:rank => 5 },
                              { :strain_id => 1,:rank => 4 },
                              { :strain_id => 13,:rank => 4 },
                              { :strain_id => 14,:rank => 4 },
                              { :strain_id => 12,:rank => 4 },
                              { :strain_id => 16,:rank => 4 },
                              { :strain_id => 11,:rank => 4 }].to_s }
    let(:invalid_top_strains){[{ :strain_id => 3,:rank => 1 },
                              { :strain_id => 4,:rank => 1 },
                              { :strain_id => 2,:rank => 1 },
                              { :strain_id => 6,:rank => 1 },
                              { :strain_id => 1,:rank => 1 },
                              { :strain_id => 3,:rank => 1 },
                              { :strain_id => 4,:rank => 1 },
                              { :strain_id => 2,:rank => 1 },
                              { :strain_id => 6,:rank => 1 },
                              { :strain_id => 1,:rank => 1 }].to_s }
    
    describe 'failure' do
      it 'should create notification with no top_strains' do
        User.any_instance.stubs(:top_strains).returns(nil)
        lambda { visit user_verification_path(@user.perishable_token) }.should change(Notification,:count).from(0).to(1)
      end
      
      it 'should create notification with rank too low' do
        User.any_instance.stubs(:top_strains).returns(invalid_top_strains)
        lambda { visit user_verification_path(@user.perishable_token) }.should change(Notification,:count).from(0).to(1)
      end
      
      it 'should send an email about not enough top strains'
    end
    
    describe 'success' do
      it 'should send email for top strain and create notification' do
        User.any_instance.stubs(:top_strains).returns(valid_top_strains)
        visit user_verification_path(@user.perishable_token)
        
        jobs_pending.should eq(1)
        lambda { perform_all_pending_jobs.should eq(1) }.should change(Notification,:count).from(0).to(1)
        
        last_email.subject.should eq(top_strain_email_subject)
        last_email.to.should include(@user.email)
      end
    end
  end
end
