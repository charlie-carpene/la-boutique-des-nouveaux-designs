# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

Category.destroy_all
Shop.destroy_all
Address.destroy_all
User.destroy_all
puts "Seed destroyed"

Category.create(name: "Mode")
Category.create(name: "Maison")
Category.create(name: "Vie Quotidienne")
Category.create(name: "Enfant")
puts "Categories created"

User.create(email: "charlie@yopmail.com", password: "password", password_confirmation: "password", is_maker: true)
puts "Maker charlie@yopmail.com created"

Address.create(first_name: "Charlie", last_name: "Carpene", address_line_1: "31 rue du 4 aout 1789", address_line_2: "", zip_code: "69100", city: "Villeurbanne", user: User.find_by(email: "charlie@yopmail.com"))
Address.create(first_name: "Jonas", last_name: "Thevenon", address_line_1: "Rue  de panam", address_line_2: "", zip_code: "75020", city: "Paris", user: User.find_by(email: "charlie@yopmail.com"))
puts "charlie@yopmail.com addresses created"

Shop.create(brand: "ShowerChiottes", website: "www.showerchiott.es", email_pro: "charlie@yopmail.com", description: Faker::Quote.famous_last_words, user: User.find_by(email: "charlie@yopmail.com"))
puts "Shop created"

puts "-" * 30
puts "Seed success"
puts "-" * 30
