require 'spec_helper'
support_require 'vcr'
support_require 'redis'


describe Geocode do
  it 'should respond to :perform' do
    Geocode.should respond_to(:perform)
  end
  
  after(:all) do
    clear_resque(['critical','high','medium','low'])
  end
  
  it 'should get longitude and latitude for Club', :vcr do
    FakeWeb.allow_net_connect = false
    
    club = Factory(:club)
    Geocode.perform(club.id)
    club.reload
    (club.longitude).round(2).should eq(-118.02)
    club.latitude.round(2).should eq(34.15)
  end
end