# Cars
class Car
  attr_accessor :id, :price_per_day, :price_per_km
  def initialize(props)
    @id = props[:id]
    @price_per_day = props[:price_per_day]
    @price_per_km = props[:price_per_km]
  end
end
