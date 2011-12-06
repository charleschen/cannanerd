require 'spec_helper'
support_require 'helper'

describe UpdateTopStrain do
  let(:user) { Factory(:user) }
                
  before(:each) do
    questionnaire = Questionnaire.create()
  end
  
  it 'should respond to :peform' do
    UpdateTopStrain.should respond_to(:perform)
  end
    
  it 'should require a user_id' do
    lambda { UpdateTopStrain.perform }.should raise_error
  end
  
  it 'should not give top strains if user.tag_list is empty or nil' do
    User.any_instance.stubs(:update_tag_list!).returns(nil)
    curr_user = user
    
    lambda {UpdateTopStrain.perform(curr_user.id)}.should raise_error
    
    User.any_instance.stubs(:update_tag_list!).returns("")
    lambda {UpdateTopStrain.perform(curr_user.id)}.should raise_error
  end
  
  it 'should give the right top strain' do
    tag_num = 5
    tag_list = list_of_unique_names(tag_num)
    rand_list = (0..tag_num-1).to_a.sort{ rand() - 0.5 }
    
    Club.any_instance.stubs(:get_geocode).returns(true)
    club = Factory(:club)
    
    top_strain_ids = []
    
    tag_num.times do |count|
      strain = Factory(:strain, :name => Faker::Name.name)
      strain.tag_list.add(tag_list[0..rand_list[count]])
      strain.save
      strain.reload
      
      top_strain_ids[tag_num - 1 - rand_list[count]] = { :strain_id => strain.id, :rank => rand_list[count]+1 }
      
      club.add_to_inventory!(strain)
    end
    
    User.any_instance.stubs(:update_tag_list!).returns(tag_list)
    
    Club.stubs(:near).returns([club])
    curr_user = user
    UpdateTopStrain.perform(curr_user.id)
    
    curr_user.reload
    curr_user.top_strains.should eq(top_strain_ids.to_s)
  end
  
  it 'should give the right top strain, even with different contexts' do
    tag_num = 5
    tag_list = list_of_unique_names(tag_num)
    rand_list = (0..tag_num-1).to_a.sort{ rand() - 0.5 }
    
    Club.any_instance.stubs(:get_geocode).returns(true)
    club = Factory(:club)
    
    top_strain_ids = []
    
    tag_num.times do |count|
      strain = Factory(:strain, :name => Faker::Name.name)
      strain.set_tag_list_on(("#{Faker::Name.first_name}_context".to_sym), tag_list[0..rand_list[count]])
      strain.save
      strain.reload
      
      top_strain_ids[tag_num - 1 - rand_list[count]] = { :strain_id => strain.id, :rank => rand_list[count]+1 }
      
      club.add_to_inventory!(strain)
    end
    
    User.any_instance.stubs(:update_tag_list!).returns(tag_list)
    Club.stubs(:near).returns([club])
    curr_user = user
    UpdateTopStrain.perform(curr_user.id)
    
    curr_user.reload
    curr_user.top_strains.should eq(top_strain_ids.to_s)
  end
  
  it 'should give the right top strains from different clubs' do
    tag_num = 5
    tag_list = list_of_unique_names(tag_num)
    rand_list = (0..tag_num-1).to_a.sort{ rand() - 0.5 }
    
    club_list = []
    
    Club.any_instance.stubs(:get_geocode).returns(true)
    #club = Factory(:club)
    
    top_strain_ids = []
    
    tag_num.times do |count|
      strain = Factory(:strain, :name => Faker::Name.name)
      strain.set_tag_list_on(:random_context, tag_list[0..rand_list[count]])
      strain.save
      strain.reload
      
      top_strain_ids[tag_num - 1 - rand_list[count]] = { :strain_id => strain.id, :rank => rand_list[count]+1 } #[strain.id,rand_list[count]+1]
      
      name = Faker::Name.first_name
      club = Factory(:club, :email => "#{name}_#{count}@gmail.com", :name => "#{name}_#{count}")
      club.add_to_inventory!(strain)
      club_list << club
    end
    
    User.any_instance.stubs(:update_tag_list!).returns(tag_list)
    Club.stubs(:near).returns(club_list)
    curr_user = user
    UpdateTopStrain.perform(curr_user.id)
    
    curr_user.reload
    curr_user.top_strains.should eq(top_strain_ids.to_s)
  end
end