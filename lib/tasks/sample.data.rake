namespace :db do
  desc 'Fill database with sample data'
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_admins
    make_users
    make_clubs
    
    make_questions_and_answers
  end
end


def make_admins
  user = User.create!(  :email                  => "ccchen920@gmail.com",
                  :name                   => "Charles Chen",
                  :password               => "snape",
                  :password_confirmation  => "snape")
  
  user.roles = ['member','admin']
  
  user = User.create!(  :email                  => "andtsai@gmail.com",
                  :name                   => "Andrew Tsai",
                  :password               => "muhfuh",
                  :password_confirmation  => "muhfuh")
  user.roles = ['member','admin']
end


def make_users
  user = User.create!( :email                  => 'bob@gmail.com',
                :name                   => "Bob Dylon",
                :password               => "password",
                :password_confirmation  => "password")
                
  user.roles = ['member']
                
  5.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@example.com"
    password = "password"
    User.create!( :email                  => email,
                  :name                   => name,
                  :password               => password,
                  :password_confirmation  => password)
  end
end

def make_clubs
  club = Club.create!( :email                  => 'club@gmail.com',
                :name                   => "Mj Club",
                :password               => "password",
                :password_confirmation  => "password")
  
  club.roles = ['registered']
  
  3.times do |n|
    name = Faker::Name.name
    email = "exampleclub-#{n+1}@example.com"
    password = "password"
    Club.create!( :email                  => email,
                  :name                   => name,
                  :password               => password,
                  :password_confirmation  => password)
  end
end

def make_questions_and_answers
  questionnaire = Questionnaire.create
  
  question = questionnaire.questions.create(:content => "How much would you pay for an eighth of an ounce of weed?", :multichoice => true)
  question.answers.create(:content => "40-50 dollars")
  question.answers.create(:content => "50-60 dollars")
  question.answers.create(:content => "60-70 dollars")
  
  question = questionnaire.questions.create(:content => "How much would you pay for an eighth of an ounce of weed?")
  question.answers.create(:content => "body")
  question.answers.create(:content => "mind")
  question.answers.create(:content => "both")
  question.answers.create(:content => "body or mind")
  
  multi_choice = false
  
  12.times do 
    question = questionnaire.questions.create(:content => Faker::Lorem.sentence(10), :multichoice => multi_choice)
    multi_choice = !multi_choice
    3.times do
      question.answers.create(:content => Faker::Lorem.words(4))
    end
  end
  
end