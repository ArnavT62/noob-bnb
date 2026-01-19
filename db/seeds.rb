# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Set Faker locale to English
Faker::Config.locale = 'en'
user = User.create({
  email: 'test@example.com',
  password: 'password'
})
6.times do |i|
   property =  Property.create({
      name: Faker::Address.full_address,
      description: Faker::Lorem.paragraph(sentence_count: 10),
      headline: Faker::Lorem.unique.sentence(word_count: 6),
      address_1: Faker::Address.street_address,
      address_2: Faker::Address.street_name,
      city: Faker::Address.city,
      state: Faker::Address.state,
      country: Faker::Address.country,
      price: Money.from_amount((50..100).to_a.sample, 'USD'),
      guest_count: (1..10).to_a.sample,
      bedroom_count: (1..5).to_a.sample,
      bed_count: (1..10).to_a.sample
    })
    # Attach images if they exist (optional - images can be added via admin panel)
    image_files = Dir.glob("db/images/property_*.jpeg")
    if image_files.any?
      # Attach a few random images from available files
      image_files.sample([image_files.length, 4].min).each do |image_path|
        property.images.attach(io: File.open(image_path), filename: File.basename(image_path))
      end
    end


  end