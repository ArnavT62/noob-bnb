# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Property.create([
  {
    name: "4 Person Villa",
    headline: "4 Person Villa",
    description: "It is a beautiful4 Person Villa on the beachfront with a pool and a garden.",
    address_1: "123, Baga Beach, Panaji",
    address_2: "Apt 1",
    city: "Panaji",
    state: "Goa",
    country: "India"
  }
 ])

 
Property.create([
    {
      name: "2 Person Villa",
      headline: "2 Person Villa",
      description: "It is a beautiful 2 Person Villa on the beachfront with a pool and a garden.",
      address_1: "123, Calangute Beach, Calangute",
      address_2: "Apt 1",
      city: "Calangute",
      state: "Goa",
      country: "India"
    }
   ])