require_relative '../models/rental'
require_relative '../models/action'

# Repository of cars
class RentalRepository
  def initialize(rental, car_repository)
    @rentals = []
    @input = rental
    @car_repository = car_repository
    load_rentals
  end

  def all
    @rentals
  end

  def find(id)
    @rentals.find { |rental| rental.id == id }
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
