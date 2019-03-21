class HasHGeo < Predicate
  def initialize(has_geo, has_latitude, has_longitude)
    @has_geo = has_geo
    @has_latitude = has_latitude
    @has_longitude = has_longitude
  end

  def validate(hevent)
    @has_geo.validate(hevent)
    @has_latitude.validate(hevent.geo)
    @has_longitude.validate(hevent.geo)
  end
end
