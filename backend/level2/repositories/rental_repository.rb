require 'json'
require_relative '../models/rental'

# Repository of cars
class RentalRepository
  def initialize(json, car_repository)
    @rentals = []
    @input = json
    @car_repository = car_repository
    load_rentals
  end

  def all
    @rentals
  end

  private

  def load_rentals
    @input.each do |rental|
      new_rental = Rental.new(
        id: rental[:id],
        car_id: @car_repository.find(rental[:car_id]),
        start_date: Date.parse(rental[:start_date], '%F'),
        end_date: Date.parse(rental[:end_date], '%F'),
        distance: rental[:distance]
      )
      @rentals << new_rental
    end
  end
end
