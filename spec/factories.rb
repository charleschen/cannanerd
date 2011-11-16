Factory.define :user do |user|
  user.email                  'bob@example.com'
  user.name                   'bob hope'
  user.password               'password'
  user.password_confirmation  'password'
  user.zipcode                '91006'
end

Factory.define :club do |club|
  club.email                  'mjclub@example.com'
  club.name                   'MJ Club'
  club.password               'password'
  club.password_confirmation  'password'
  club.address                '346 Laurel Avenue, CA, 91006'
end

Factory.define :answer do |answer|
  answer.content              'this is an answer'
  answer.old_content          'this is the old answer'
end

Factory.define :tag do |tag|
  tag.name                    'indica'
  tag.category                'strain'
end

Factory.define :question do |question|
  question.content            'Best team in the NBA?'
end

Factory.define :quiz do |quiz|
  
end

Factory.define :strain do |strain|
  strain.name               'OG Kush'
  strain.id_str            'ogk'
  strain.description        'this is marijuana'
end