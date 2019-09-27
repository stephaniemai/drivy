# Class Rental Option
class Option
  attr_accessor :type, :amount, :rental
  def initialize(props)
    @id = props[:id]
    @rental = props[:rental_id]
    @type = props[:type]
    @amount = props[:amount]
  end
end
