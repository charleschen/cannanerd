require 'spec_helper'

describe "InitDashboards" do
  it 'should be able to reroute to root_path with no login' do
    visit dashboards_path
    current_path.should == root_path
  end
end
