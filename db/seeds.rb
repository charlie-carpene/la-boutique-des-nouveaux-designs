# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

Admin.destroy_all
Order.destroy_all
Item.destroy_all
Category.destroy_all
Shop.destroy_all
Address.destroy_all
User.destroy_all
puts "Seed destroyed"

puts "-" * 30
puts "Seed starting :"
puts "-" * 30

puts "***** Categories ... *****"
Category.create(name: "Enfant")
Category.create(name: "Maison")
Category.create(name: "Mode")
Category.create(name: "Quotidien")
puts "... done"

puts "***** Admin with addresses & shop ... *****"
User.create(email: "atelier@nouveauxdesigns.fr", password: "password", password_confirmation: "password", is_maker: true)
Admin.create(user: User.find_by(email: "atelier@nouveauxdesigns.fr"))
Address.create(first_name: "Charlie", last_name: "Carpene", address_line_1: "31 rue du 4 aout 1789", address_line_2: "", zip_code: "69100", city: "Villeurbanne", user: User.find_by(email: "atelier@nouveauxdesigns.fr"))
Address.create(first_name: "Jonas", last_name: "Thevenon", address_line_1: "Rue de panam", address_line_2: "", zip_code: "75020", city: "Paris", user: User.find_by(email: "atelier@nouveauxdesigns.fr"))
Shop.create(brand: "ShowerChiottes", website: "www.showerchiott.es", email_pro: "atelier@nouveauxdesigns.fr", description: Faker::Quote.famous_last_words, user: User.find_by(email: "atelier@nouveauxdesigns.fr"), compagny_id: Faker::Number.number(digits: 14))
puts "... done"

puts "***** Maker with address & shop ... *****"
User.create(email: "gradya@yopmail.com", password: "password", password_confirmation: "password", is_maker: true)
Shop.create(brand: "Gradya bg compagny", website: "www.showerchiott.es", email_pro: "gradya@yopmail.com", description: Faker::Quote.famous_last_words, user: User.find_by(email: "gradya@yopmail.com"), compagny_id: Faker::Number.number(digits: 14))
Address.create(first_name: "Gradya", last_name: "Gradya", address_line_1: "13 rue des Gobelin", address_line_2: "", zip_code: "75005", city: "Paris", user: User.find_by(email: "gradya@yopmail.com"))
puts "... done"

puts "***** Common user ... *****"
User.create(email: "gawain@yopmail.com", password: "password", password_confirmation: "password")
Address.create(first_name: "Gawain", last_name: "Vincent", address_line_1: "20 rue des Gobelins", address_line_2: "", zip_code: "75005", city: "Paris", user: User.find_by(email: "gawain@yopmail.com"))
puts "... done"

puts "***** Items ... *****"
10.times do
  Item.create(name: Faker::Creature::Cat.name, category: Category.all.sample, description: Faker::TvShows::HowIMetYourMother.quote, price: Faker::Number.number(digits:2), product_weight: Faker::Number.between(from: 1, to: 30000), available_qty: Faker::Number.number(digits:1), shop: Shop.all.sample)
end
puts "... done"

puts "-" * 30
puts "Seed success"
puts "-" * 30
