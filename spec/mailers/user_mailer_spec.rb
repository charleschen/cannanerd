require "spec_helper"

describe UserMailer do
  let(:club) do
    Club.any_instance.stubs(:get_geocode).returns(true)
    Factory(:club)
  end
  
  before(:each) do
    @email_from = "cannanerds@gmail.com"
    @verification_subject = "User account verification from Cannaerd"
    @top_strains_subject = "Top strains"
  end
  
  describe "deliver_registration_confirmation" do
    let(:user){ Factory(:user, :perishable_token => "token")}
    let(:mail){ UserMailer.registration_confirmation(user)}
    
    it "should send user verification url" do
      mail.subject.should eq(@verification_subject)
      mail.to.should eq([user.email])
      mail.from.should eq([@email_from])
      mail.body.encoded.should match(user_verification_path(user.perishable_token))
    end
  end
  
  describe "deliver_top_strains" do
    #let(:user){ Factory(:user) }
    #let(:mail){ UserMailer.top_strains(user) }
    before(:each) do
      @user = Factory(:user)
    end
    
    it 'should send user top strains' do
      strain_list = []
      5.times do |count|
        rand = 'a'*count
        strain_list << Factory(:strain, :club_id => club.id, :name => "#{Faker::Name.first_name}#{rand}").id
      end
      User.any_instance.stubs(:latest_picked_strain_ids).returns(strain_list)
      
      sent_mail = UserMailer.top_strains(@user)
      
      sent_mail.subject.should eq(@top_strains_subject)
      sent_mail.to.should eq([@user.email])
      sent_mail.from.should eq([@email_from])
      
      strain_list.each do |strain_id|
        sent_mail.body.encoded.should match(Strain.find(strain_id).name)
      end
    end
  end
  
end
