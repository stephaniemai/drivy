# Repository of actions
class ActionRepository
  def initialize(rental_repository)
    @rental_repository = rental_repository
    @actions = []
  end
end
