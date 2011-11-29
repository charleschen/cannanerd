require 'spec_helper'
support_require 'mailer_macros'

describe SendUserMail do
  let(:user) { Factory(:user) }
  
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
end