require_relative '../models/option'
OPTIONS = {
  gps: 500,
  baby_seat: 200,
  additional_insurance: 1000
}.freeze
# Repository of rental options
class OptionRepository
  def initialize(json, rental_repository)
    @input = json
    @rental_repository = rental_repository
    @options = []
    load_options
  end

  private

  def load_options
    @input.each do |opt|
      @rental = @rental_repository.find(opt[:rental_id])
      new_option = Option.new(
        id: opt[:id],
        rental_id: @rental,
        type: opt[:type],
        amount: OPTIONS[opt[:type].to_sym] * @rental.duration
      )
      @options << new_option
      @rental.options << new_option.type
      dispatch_option_amount(new_option)
    end
  end

  def dispatch_option_amount(option)
    option.rental.owner += option.amount if option.type == 'gps' || option.type == 'baby_seat'
    option.rental.commission[:drivy_fee] += option.amount if option.type == 'additional_insurance'
    option.rental.price += option.amount
  end
end
