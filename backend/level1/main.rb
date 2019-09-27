require 'json'
require 'date'

# Read the input data
inputpath = 'data/input.json'
serialized_data = File.read(inputpath)
data = JSON.parse(serialized_data)
cars = data['cars']
rentals = data['rentals']

# Prepare the output data
output = { 'rentals': [] }

rentals.each do |rental|
  # Get the rented car data
  car = cars.select { |r| r['id'] == rental['car_id'] }[0]
  # Calculate the rental distance price
  price_distance = car['price_per_km'].to_i * rental['distance'].to_i
  # Calculate the rental duration
  start_date = Date.parse(rental['start_date'], '%F')
  end_date = Date.parse(rental['end_date'], '%F')
  duration = (end_date - start_date).to_i + 1
  # Calculate the rental duration price
  price_duration = car['price_per_day'].to_i * duration
  # Calculate the rental total price
  price = price_distance + price_duration
  # Add the data the output
  output[:rentals] << {
    'id': rental['id'],
    'price': price
  }
end

# Generate the JSON output file
outputpath = 'data/output.json'
File.open(outputpath, 'wb') do |file|
  file.write(JSON.pretty_generate(output))
  file << "\n"
end
