require_relative './has_field'

class HasHAdr < Predicate
  def initialize(has_address, *adr_predicates)
    @has_address = has_address
    @adr_predicates = adr_predicates
  end

  def validate(hevent)
    @has_address.validate(hevent)
    @adr_predicates.each do |p|
      p.validate(hevent.location)
    end
  end
end
