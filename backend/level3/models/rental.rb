require 'date'
# Rentals
class Rental
  attr_accessor :id, :price, :commission
  def initialize(props)
    @id = props[:id]
    @car = props[:car_id]
    @start_date = props[:start_date]
    @end_date = props[:end_date]
    @distance = props[:distance]
    @duration = @end_date - @start_date + 1
    @price = calculate_price(@duration, @distance, @car)
    @commission = calculate_commission(@price)
  end

  private

  def get_price_duration_rate(duration)
    if duration > 10
      rate = 0.5
    else
      case duration
      when 5..10
        rate = 0.7
      when 2..4
        rate = 0.9
      when 1
        rate = 1
      end
    end
    rate
  end

  def calculate_price_duration(duration, car)
    price_duration = 0
    until duration.zero?
      rate = get_price_duration_rate(duration)
      price_duration += (car.price_per_day * rate).to_i
      duration -= 1
    end
    price_duration
  end

  def calculate_price(duration, distance, car)
    @distance_price = (car.price_per_km * distance).to_i
    @duration_price = calculate_price_duration(duration, car)
    @distance_price + @duration_price
  end

  def calculate_commission(price)
    commission = {}
    commission_basis = (price * 0.3)
    commission[:insurance_fee] = (commission_basis * 0.5).to_i
    commission[:assistance_fee] = (@duration * 100).to_i
    commission[:drivy_fee] = (commission_basis - (commission[:insurance_fee] + commission[:assistance_fee])).to_i
    commission
  end
end
