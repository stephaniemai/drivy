require 'json'
require 'date'

require_relative 'repositories/car_repository'
require_relative 'repositories/rental_repository'

# Read the input data and store it in a variable
inputpath = 'data/input.json'
serialized_data = File.read(inputpath)
data = JSON.parse(serialized_data, symbolize_names: true)

# Populate the repositories with the input data
car_repository = CarRepository.new(data[:cars])
rental_repository = RentalRepository.new(data[:rentals], car_repository)

# Prepare the data output
output = { rentals: [] }

def list_actions(rental)
  action_list = []
  rental.actions.each do |action|
    a = {
      who: action.who,
      type: action.type,
      amount: action.amount
    }
    action_list << a
  end
  action_list
end

rental_repository.all.each do |rental|
  r = {
    id: rental.id,
    actions: list_actions(rental)
  }
  output[:rentals] << r
end

# Generate the output
outputpath = 'data/output.json'
File.open(outputpath, 'wb') do |file|
  file.write(JSON.pretty_generate(output))
  file << "\n"
end
