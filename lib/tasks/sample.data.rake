namespace :db do
  desc 'Fill database with sample data'
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_admins
    make_users
  end
end


def make_admins
  user = User.create!(  :email                  => "ccchen920@gmail.com",
                  :name                   => "Charles Chen",
                  :password               => "snape",
                  :password_confirmation  => "snape")
  
  user.roles = [:member,:admin]
  
  user = User.create!(  :email                  => "andtsai@gmail.com",
                  :name                   => "Andrew Tsai",
                  :password               => "muhfuh",
                  :password_confirmation  => "muhfuh")
  user.roles = [:member,:admin]
end


def make_users
  User.create!( :email                  => 'bob@gmail.com',
                :name                   => "Bob Dylon",
                :password               => "password",
                :password_confirmation  => "password")
                
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
