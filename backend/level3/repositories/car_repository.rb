require 'json'
require_relative '../models/car'

# Repository of cars
class CarRepository
  def initialize(json)
    @cars = []
    @input = json
    load_cars
  end

  def all
    @cars
  end

  def find(id)
    @cars.find { |car| car.id == id }
  end

  private

  def load_cars
    @input.each do |car|
      @cars << Car.new(car)
    end
  end
end
