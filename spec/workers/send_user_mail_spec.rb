require 'spec_helper'
support_require 'mailer_macros'

describe SendUserMail do
  let(:user) { Factory(:user) }
  
  before(:each) do
    reset_email
  end
  
  it 'should respond to :perform' do
    SendUserMail.should respond_to(:perform)
  end
  
  it 'should be able to perform registration_confirmation method' do
    SendUserMail.perform(:registration_confirmation, user.id)
  end
  
  it 'registration_confirmation method should send email' do
    @user = user
    SendUserMail.perform(:registration_confirmation, @user.id)
    last_email.to.should include(@user.email)
  end
  
  it 'should be able to perform top_strains method' do
    Strain.stubs(:where).returns([Factory(:strain)])
    User.any_instance.stubs(:latest_picked_strain_ids).returns([])
    SendUserMail.perform(:top_strains, user.id)
  end
  
  it 'top_strains method should send email' do
    Strain.stubs(:where).returns([Factory(:strain)])
    User.any_instance.stubs(:latest_picked_strain_ids).returns([])
    @user = user
    SendUserMail.perform(:top_strains, @user.id)
    last_email.to.should include(@user.email)
  end
  
  it 'top_strains method should create a new notification about email sent' do
    Strain.stubs(:where).returns([Factory(:strain)])
    User.any_instance.stubs(:latest_picked_strain_ids).returns([])
    @user = user
    
    lambda{ SendUserMail.perform(:top_strains, @user.id) }.should change(Notification,:count).from(0).to(1)
    
    @user.notifications.created_order.first.content.should =~ /top strains/i
  end
end