require "spec_helper"

describe UserMailer do
  before(:each) do
    @email_from = "cannanerds@gmail.com"
    @verification_subject = "User account verification from Cannaerd"
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
  
end
