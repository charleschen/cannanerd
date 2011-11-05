Factory.define :user do |user|
  user.email                  'bob@example.com'
  user.name                   'bob hope'
  user.password               'password'
  user.password_confirmation  'password'
end