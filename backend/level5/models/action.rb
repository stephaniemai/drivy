# Action
class Action
  attr_accessor :who, :type, :amount
  def initialize(props)
    @who = props[:who]
    @type = props[:type]
    @amount = props[:amount]
  end
end
