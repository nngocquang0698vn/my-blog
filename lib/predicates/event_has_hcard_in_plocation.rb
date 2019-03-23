require_relative './predicate'

class EventHasHcardInPlocation < Predicate
  def initialize(has_plocation, *hcard_predicates)
    @has_plocation = has_plocation
    @hcard_predicates = hcard_predicates
  end

  def validate(hevent)
    @has_plocation.validate(hevent)
    @hcard_predicates.each do |p|
      p.validate(hevent.location)
    end
  end
end
