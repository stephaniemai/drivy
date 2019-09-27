require 'json'
require 'date'

require_relative 'repositories/car_repository'
require_relative 'repositories/rental_repository'
require_relative 'repositories/option_repository'

# Read the input data and store it in a variable
inputpath = 'data/input.json'
serialized_data = File.read(inputpath)
data = JSON.parse(serialized_data, symbolize_names: true)

# Populate the repositories with the input data
car_repository = CarRepository.new(data[:cars])
rental_repository = RentalRepository.new(data[:rentals], car_repository)
OptionRepository.new(data[:options], rental_repository)

# Prepare the data output
output = { rentals: [] }

rental_repository.all.each do |rental|
  rental.generate_actions(rental)
  r = {
    id: rental.id,
    options: rental.options,
    actions: rental.list_actions(rental)
  }
  output[:rentals] << r
end

# Generate the output
outputpath = 'data/output.json'
File.open(outputpath, 'wb') do |file|
  file.write(JSON.pretty_generate(output))
  file << "\n"
end
