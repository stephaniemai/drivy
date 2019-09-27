require 'date'
# Rentals
class Rental
  attr_accessor :id, :options, :duration, :price, :commission, :owner, :actions
  def initialize(props)
    @id = props[:id]
    @car = props[:car_id]
    @start_date = props[:start_date]
    @end_date = props[:end_date]
    @distance = props[:distance]
    @options = []
    @duration = (@end_date - @start_date).to_i + 1
    @price = calculate_price
    @commission = calculate_commission
    @owner = calculate_owner
    @actions = []
  end

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

  def generate_actions(rental)
    price_breakdown = {
      driver: rental.price,
      owner: rental.owner,
      insurance: rental.commission[:insurance_fee],
      assistance: rental.commission[:assistance_fee],
      drivy: rental.commission[:drivy_fee]
    }
    price_breakdown.each do |k, v|
      new_action_props = create_action(k, v)
      new_action = Action.new(new_action_props)
      rental.actions.push(new_action)
    end
    rental.actions
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

  def calculate_price_duration(duration)
    price_duration = 0
    until duration.zero?
      rate = get_price_duration_rate(duration)
      price_duration += (@car.price_per_day * rate).to_i
      duration -= 1
    end
    price_duration
  end

  def calculate_price
    distance_price = @car.price_per_km * @distance
    duration_price = calculate_price_duration(@duration)
    distance_price + duration_price
  end

  def calculate_commission
    commission_basis = (@price * 0.3)
    commission = {
      insurance_fee: (commission_basis * 0.5).to_i,
      assistance_fee: (@duration * 100).to_i
    }
    commission[:drivy_fee] = \
      (commission_basis - \
      (commission[:insurance_fee] + commission[:assistance_fee]) \
      ).to_i
    commission
  end

  def calculate_owner
    price_basis = @price - @commission.map { |_k, v| v }.reduce(0, :+)
    return price_basis if @options.empty?
  end

  def create_action(role, amount)
    {
      who: role,
      type: role.to_s == 'driver' ? 'debit' : 'credit',
      amount: amount
    }
  end
end
