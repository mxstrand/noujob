# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

{
  "mike@mike.com" => "password",
  "hamid@hamid.com" => "password",
}.each do |email, password|
  User.create(email: email.dup, password: password)
  # email must be .dup'ed as Devise tries to downcase all email entries
  # and the create method will not allow altering of source hash key values
end
User.update_all(:confirmed_at => Time.now)
