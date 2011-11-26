def list_of_unique_names(num_of_names)
  list = []
  name = Faker::Name.first_name
  num_of_names.times do
    name = Faker::Name.first_name while(list.include?(name))
    list << name
  end
  list
end