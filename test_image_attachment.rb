# test_image_attachment.rb

require 'open-uri'
require 'uri'

# Load Rails environment
require_relative 'config/environment'

# Example product and image URL
product = Product.first
image_url = "https://i0.wp.com/www.zaytoonwpg.com/wp-content/uploads/2021/08/website-square-6-1.jpg?fit=1024%2C1024&ssl=1"

begin
  downloaded_image = URI.open(image_url)
  product.images.attach(io: downloaded_image, filename: File.basename(URI.parse(image_url).path))
  product.save!
  puts "Image successfully attached to product: #{product.name}"
rescue OpenURI::HTTPError, URI::InvalidURIError, Errno::ENOENT => e
  puts "Error downloading image: #{e.message}"
end
