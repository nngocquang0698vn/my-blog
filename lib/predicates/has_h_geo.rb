class HasHGeo < Predicate
  def initialize(has_geo, *geo_predicates)
    @has_geo = has_geo
    @geo_predicates = geo_predicates
  end

  def validate(hevent)
    @has_geo.validate(hevent)
    @geo_predicates.each do |p|
      p.validate(hevent.location)
    end
  end
end
