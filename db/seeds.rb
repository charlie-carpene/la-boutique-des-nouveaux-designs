# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

Category.destroy_all
Maker.destroy_all
puts "Seed destroyed"

Category.create(name: "Mode")
Category.create(name: "Maison")
Category.create(name: "Vie Quotidienne")
Category.create(name: "Enfant")
puts "Categories created"

Maker.create(brand: "Best Brand Ever", website: "www.showerchiott.es", description: Faker::Quote.famous_last_words, user: User.find_by(email: "charlie@yopmail.com"))
