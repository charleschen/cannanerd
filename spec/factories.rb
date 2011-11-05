Factory.define :user do |user|
  user.email                  'bob@example.com'
  user.name                   'bob hope'
  user.password               'password'
  user.password_confirmation  'password'
end

Factory.define :club do |club|
  club.email                  'mjclub@example.com'
  club.name                   'MJ Club'
  club.password               'password'
  club.password_confirmation  'password'
end