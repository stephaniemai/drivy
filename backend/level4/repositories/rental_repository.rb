require 'json'
require_relative '../models/rental'
require_relative '../models/action'

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

  def generate_actions(rental)
    price_breakdown = {
      driver: { who: 'driver', type: 'debit', amount: rental.price },
      owner: { who: 'owner', type: 'credit', amount: rental.owner },
      insurance: {
        who: 'insurance',
        type: 'credit',
        amount: rental.commission[:insurance_fee]
      },
      assistance: {
        who: 'assistance',
        type: 'credit',
        amount: rental.commission[:assistance_fee]
      },
      drivy: {
        who: 'drivy',
        type: 'credit',
        amount: rental.commission[:drivy_fee]
      }
    }
    price_breakdown.each do |who|
      new_action = Action.new(who[1])
      rental.actions.push(new_action)
    end
    rental.actions
  end

  def load_rentals
    @input.each do |rental|
      new_rental = Rental.new(
        id: rental[:id],
        car_id: @car_repository.find(rental[:car_id]),
        start_date: Date.parse(rental[:start_date], '%F'),
        end_date: Date.parse(rental[:end_date], '%F'),
        distance: rental[:distance]
      )
      new_rental.actions = generate_actions(new_rental)
      @rentals << new_rental
    end
  end
end
