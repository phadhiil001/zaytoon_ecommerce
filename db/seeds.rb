# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?


Province.create([
  { name: 'Alberta', gst: 0.05, pst: 0.00, hst: 0.00, qst: 0.00 },
  { name: 'British Columbia', gst: 0.05, pst: 0.07, hst: 0.00, qst: 0.00 },
  { name: 'Manitoba', gst: 0.05, pst: 0.08, hst: 0.00, qst: 0.00 },
  { name: 'New Brunswick', gst: 0.00, pst: 0.00, hst: 0.15, qst: 0.00 },
  { name: 'Newfoundland and Labrador', gst: 0.00, pst: 0.00, hst: 0.15, qst: 0.00 },
  { name: 'Nova Scotia', gst: 0.00, pst: 0.00, hst: 0.15, qst: 0.00 },
  { name: 'Ontario', gst: 0.00, pst: 0.00, hst: 0.13, qst: 0.00 },
  { name: 'Prince Edward Island', gst: 0.00, pst: 0.00, hst: 0.15, qst: 0.00 },
  { name: 'Quebec', gst: 0.05, pst: 0.00, hst: 0.00, qst: 0.09975 },
  { name: 'Saskatchewan', gst: 0.05, pst: 0.06, hst: 0.00, qst: 0.00 }
])
