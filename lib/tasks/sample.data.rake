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
                  :password_confirmation  => "snape",
                  :zipcode                => '91006')
  
  user.roles = ['member','admin']
  
  user = User.create!(  :email                  => "andtsai@gmail.com",
                  :name                   => "Andrew Tsai",
                  :password               => "muhfuh",
                  :password_confirmation  => "muhfuh",
                  :zipcode                => '90017')
  user.roles = ['member','admin']
end


def make_users
  user = User.create!( :email                  => 'bob@gmail.com',
                :name                   => "Bob Dylon",
                :password               => "password",
                :password_confirmation  => "password",
                :zipcode                => "90048")
                
  user.roles = ['member']
                
  5.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@example.com"
    password = "password"
    User.create!( :email                  => email,
                  :name                   => name,
                  :password               => password,
                  :password_confirmation  => password,
                  :zipcode                => '92037')
  end
end

def make_clubs
  club = Club.create!( :email                  => 'club@gmail.com',
                :name                   => "Mj Club",
                :password               => "password",
                :password_confirmation  => "password",
                :address                => "1420 Oak Meadow Road, CA 91006")
  
  club.roles = ['registered']
  
  
  club = Club.create!( :email                  => 'werd@gmail.com',
                :name                   => "Werd Club",
                :password               => "password",
                :password_confirmation  => "password",
                :address                => "50 Alta Street, CA 91006")
  
  club.roles = ['registered']
  
  addresses = ['2575 W Pico Blvd, Los Angeles, CA 90006', '465 S. La Cienega Boulevard, LA, CA 90048','1111 S Figueroa St, Los Angeles, CA 90015']
  
  3.times do |n|
    name = Faker::Name.name
    email = "exampleclub-#{n+1}@example.com"
    password = "password"
    Club.create!( :email                  => email,
                  :name                   => name,
                  :password               => password,
                  :password_confirmation  => password,
                  :address                => addresses[n])
  end
end

def make_questions_and_answers
  questionnaire = Questionnaire.create
  
  tag_types = [:flavors, :types, :conditions, :symptoms, :effects, :prices]
  default_tags = %w(Sweet, Indica, Anxiety)
  
  ids = []
  
  strains = [ {:name => "Jack Herer", :description => Faker::Lorem.paragraph},
              {:name => "White Widow", :description => Faker::Lorem.paragraph},
              {:name => "Afghan Diesel", :description => Faker::Lorem.paragraph},
              {:name => "Afghan Kush", :description => Faker::Lorem.paragraph},
              {:name => "Black Diesel", :description => Faker::Lorem.paragraph},
              {:name => "Blue Champange", :description => Faker::Lorem.paragraph},
              {:name => "Blue Dragon", :description => Faker::Lorem.paragraph},
              {:name => "Blue OG", :description => Faker::Lorem.paragraph},
              {:name => "Blue Rhino", :description => Faker::Lorem.paragraph},
              {:name => "Ice Cream", :description => Faker::Lorem.paragraph},
              {:name => "Jupiter Kush", :description => Faker::Lorem.paragraph}]
              
  strains.each do |strain|
    new_strain = Club.first.strains.create(:name => strain[:name], :description => strain[:description])
    3.times do |count|
      new_strain.set_tag_list_on(tag_types[count],default_tags[count])
    end
    
    new_strain.save
    
    ids << new_strain.id
  end
  
  #Club.find_by_email('club@gmail.com').strains_in_inventory_ids = ids[0..4]
  #Club.find_by_email('werd@gmail.com').strains_in_inventory_ids = ids[5..9]
  
  strain = Strain.find_by_name("Jack Herer")
  strain.tag_list_on(:prices).add("$25 - $45")
  strain.save
  
  strain = Strain.find_by_name("White Widow")
  strain.tag_list_on(:prices).add("$65+")
  strain.save
  
  strain = Strain.find_by_name("Ice Cream")
  strain.tag_list_on(:prices).add("$45 - $65")
  strain.save
  
  answers = []
  
  answers[0] = %w(Aroused Energetic Focused)
  # Happy Lazy Talkative Uplifted Creative Euphoric Giggly Hungry Sleepy Tingly
  answers[1] = %w(Anxiety ADD Asthma)
  # Cancer Depression Epilepsy Glaucoma HIV/AIDS Insomia lack-of-appetite migraines Muscle-Spasms Nausea Pain PMS PTSD Seizuers Stress Other
  answers[2] = %w(Indica Sativa Hybrid)
  answers[3] = %w(Sweet Sour Minty Spicy Earthy)
  answers[4] = %w(Joint Pipe Bong Vaporizer)
  answers[5] = ["$25 - $45","$45 - $65","$65+"]
  
  questions = [ "You like it when your bud makes you feel:",
                "You want your bud to help you with:",
                "What kind of bud do you like?",
                "What kind of flavors do you like?",
                "How do you like to medicate?",
                "What is your price range for an 1/8 oz. of cannabis?" ]
  
  multichoice = [true,true,true,true,true,false]
  
  6.times do |count|
    question = questionnaire.questions.create(:content => questions[count], :multichoice => multichoice[count])
    answers[count].each do |answer|
      created_answer = question.answers.create(:content => answer)
      created_answer.tag_list.add(answer)
      created_answer.save
    end
  end
  
end