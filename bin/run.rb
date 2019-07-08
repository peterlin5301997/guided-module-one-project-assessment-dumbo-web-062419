require_relative '../config/environment'
require "pry"

Trip.delete_all
User.delete_all
City.delete_all

ny = City.create(name: "New York")
traveler = User.create(name: "Jahaziel")
la = City.create(name: "Los Angeles")
trip1 = traveler.trips.create
trip1.city_from = ny
trip1.city_to = la
trip1.save

binding.pry