require 'spec_helper'
require 'timecop'
support_require 'mailer_macros'
support_require 'redis'
support_require 'data_generator'
support_require 'helper'

describe "SignUpProcesses" do
  let(:logout) { 'Sign out'}
  let(:take_quiz) { page.click_link 'quiz_link' }
  let(:next_button) { 'next' }
  let(:back_button) { 'back' }
  let(:freeze_time) { Time.parse('2011-09-20 13:00:00 UTC') }
  let(:user_attr) { { :name => "Charles Chen",
                      :email    => "charleschen@gmail.com",
                      :password => 'password',
                      :zipcode => '91006'} }
  let(:queue_list) { ['critical','high','medium','low']}
  before(:each) do
    @questionnaire = Questionnaire.create!
    Questionnaire.first.update_attribute(:per_page, 1)
    create_questionaire_data  # creates 3 questions with 3 answers each, multi single multi
    Timecop.freeze(freeze_time)
    reset_email
  end
  
  after(:all) do
    Timecop.return
    clear_resque(queue_list)
  end
  
  describe 'on failure' do
    it 'on visiting user signup page' do
      visit new_user_path
      page.should have_content('Need to take questionnaire')
    end
  end
  
  it 'should start with no quiz created' do
    visit root_path
    Quiz.count.should eq(0)
    page.should have_link('quiz_link',:href => take_quiz_path)
  end
  
  it 'should create new quiz when pressing button' do
    visit root_path
    lambda {take_quiz}.should change(Quiz,:count).from(0).to(1)
    current_path.should eq(root_path)
  end
  
  describe 'questionnaire sequence' do
    before(:each) do
      visit root_path
      take_quiz
    end
    
    it 'should have only 1 question per page and navigation button' do
      page.should have_css('li.questions', :count=>1)
      page.should have_css('li#multi_answer',:count=>1)
      
      page.should have_button(next_button)
    end
    
    it 'should save answer config when going back and forth on pages' do
      check('quiz[quiziations_attributes][0][checked_answers]')
      check('quiz[quiziations_attributes][2][checked_answers]')
      
      click_button next_button
      page.should have_button back_button
      click_button back_button
      
      page.should have_checked_field('quiz[quiziations_attributes][0][checked_answers]')
      page.should have_checked_field('quiz[quiziations_attributes][2][checked_answers]')
    end
    
    it 'should save and remove selected fields' do
      check('quiz[quiziations_attributes][0][checked_answers]')
      check('quiz[quiziations_attributes][2][checked_answers]')
      
      click_button next_button
      click_button back_button
      
      uncheck('quiz[quiziations_attributes][0][checked_answers]')
      check('quiz[quiziations_attributes][1][checked_answers]')
      uncheck('quiz[quiziations_attributes][2][checked_answers]')
      
      click_button next_button
      click_button back_button
      
      page.should have_no_checked_field('quiz[quiziations_attributes][0][checked_answers]')
      page.should have_checked_field('quiz[quiziations_attributes][1][checked_answers]')
      page.should have_no_checked_field('quiz[quiziations_attributes][2][checked_answers]')
    end
    
    it 'should only select one answer for single answer' do
      question = Question.where(:multichoice => false).first
      chosen_answer = question.answers.first
      
      click_button next_button
      
      question.answers.each do |answer|
        choose("quiz_quiziations_attributes_0_radio_answer_answer_#{answer.id}1")
      end
      choose("quiz_quiziations_attributes_0_radio_answer_answer_#{chosen_answer.id}1")
      
      click_button next_button
      click_button back_button
      
      page.should have_checked_field("quiz_quiziations_attributes_0_radio_answer_answer_#{chosen_answer.id}1")
      question.answers.each do |answer|
        if answer.id != chosen_answer.id
          page.should have_no_checked_field("quiz_quiziations_attributes_0_radio_answer_answer_#{answer.id}1")
        end
      end
    end
    
    it 'should only have 3 pages' do
      click_button next_button
      click_button next_button
      page.should have_button 'submit'
    end
    
  end
  
  describe 'session timed out' do
    before(:each) do
      visit root_path
      take_quiz
    end
    
    it 'should create new quiz after 15 minutes of no update' do
      page.should_not have_link('quiz_link')
      Timecop.freeze(freeze_time + 15.minute)
      visit root_path
      page.should have_link('quiz_link')
      
      lambda {page.click_link 'quiz_link' }.should change(Quiz,:count).from(1).to(2)
    end
  end
  
  describe 'user signup' do
    before(:each) do
      visit root_path
      take_quiz
      check('quiz[quiziations_attributes][0][checked_answers]')
      check('quiz[quiziations_attributes][2][checked_answers]')
      click_button next_button
      
      question = Question.where(:multichoice => false).first
      choose("quiz_quiziations_attributes_0_radio_answer_answer_#{question.answers.first.id}1")
      click_button next_button
      
      check('quiz[quiziations_attributes][0][checked_answers]')
      click_button 'submit'
    end
    
    it 'should be in sign up page with a signup button' do
      current_path.should eq(new_user_path)
      page.should have_button 'Create User'
    end
    
    describe 'on failure' do
      it "should dispay validation errors with no fields filled in" do
        click_button 'Create User'
        page.should have_selector('div', :id=>'error_explanation')
      end
      
      it "should not create new user without same password" do
        attributes = user_attr
        fill_in "user_name",                    :with => attributes[:name]
        fill_in "user_email",                   :with => attributes[:email]
        fill_in "user_zipcode",                 :with => attributes[:zipcode]
        fill_in "user_password",                :with => attributes[:password]
        fill_in "user_password_confirmation",   :with => 'werd'
      
        lambda do
          click_button 'Create User'
        end.should_not change(User,:count)
        last_email.should be_nil
      end
    end
    
    describe 'on success' do
      before(:each) do
        @attributes = user_attr
        
        fill_in "user_name",                  :with => @attributes[:name]
        fill_in "user_email",                 :with => @attributes[:email]
        fill_in "user_zipcode",               :with => @attributes[:zipcode]
        fill_in "user_password",              :with => @attributes[:password]
        fill_in "user_password_confirmation", :with => @attributes[:password]
        
        clear_resque(queue_list)
      end
      
      it "should create user with the correct info filled in" do
        lambda do
          click_button 'Create User'
        end.should change(User,:count).by(1)
        page.should have_content("success")
        
        #jobs_pending.should eq(2)
      end
      
      it "should email user with verification details" do
        click_button 'Create User'
        
        User.any_instance.stubs(:update_tag_list!).returns('some_tag') # in order for update_top_strain to run
        Club.stubs(:near).returns([])
        
        perform_all_pending_jobs.should eq(2)
        user = User.find_by_email(@attributes[:email])
        last_email.to.should include(user.email)
      end
      
      it 'should determine top strains' do
        # same basic test as update_tag_list_spec
        tag_num = 5
        tag_list = list_of_unique_names(tag_num)
        rand_list = (0..tag_num-1).to_a.sort{ rand() - 0.5 }
        Club.any_instance.stubs(:get_geocode).returns(true)
        club = Factory(:club)
        top_strain_ids = []
        tag_num.times do |count|
          strain = Factory(:strain, :club_id => club.id, :name => Faker::Name.name)
          strain.tag_list.add(tag_list[0..rand_list[count]])
          strain.save
          strain.reload
          top_strain_ids[tag_num - 1 - rand_list[count]] = { :strain_id => strain.id, :rank => rand_list[count]+1 }
          #club.add_to_inventory!(strain)
        end
        User.any_instance.stubs(:update_tag_list!).returns(tag_list)
        Club.stubs(:near).returns([club])
        
        click_button 'Create User'
        perform_all_pending_jobs.should eq(2)
        user = User.find_by_email(@attributes[:email])
        user.top_strains.should eq(top_strain_ids.to_s)
      end
      
    end
    
    describe 'after creation' do
      before(:each) do
        attributes = user_attr
        fill_in "user_name",                  :with => attributes[:name]
        fill_in "user_email",                 :with => attributes[:email]
        fill_in "user_zipcode",               :with => attributes[:zipcode]
        fill_in "user_password",              :with => attributes[:password]
        fill_in "user_password_confirmation", :with => attributes[:password]
      
        click_button 'Create User'
      end
    
      it 'should be able to sign out' do
        page.should have_content("success")
        page.should have_link(logout)
        click_link logout
      end
    
      it 'should not be able to sign up again' do
        click_link logout
        visit new_user_path
        page.should have_content('Need to take questionnaire')
        
        visit root_path
        page.should have_link 'quiz_link'
      end
      
      
    end
          
  
  end
end
