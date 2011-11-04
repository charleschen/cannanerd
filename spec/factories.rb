Factory.define :user do |user|
  user.username               'bob hope'
  user.email                  'bob@example.com'
  user.password               'password'
  user.password_confirmation  'password'
end