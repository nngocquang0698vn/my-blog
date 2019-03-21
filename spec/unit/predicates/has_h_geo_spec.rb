require 'spec_helper'

describe 'HasHGeo' do
  let(:has_geo) { double('HasField(:geo, \'Geo\')') }
  let(:has_latitude) { double('HasPLatitude') }
  let(:has_longitude) { double('HasPLongitude') }

  let(:sut) { HasHGeo.new(has_geo, has_latitude, has_longitude) }
  let(:hevent) { double }
  let(:hgeo) { double }

  before :each do
    allow(hevent).to receive(:geo)
      .and_return hgeo

    allow(has_geo).to receive(:validate)
      .with(hevent)
    allow(has_latitude).to receive(:validate)
      .with(hgeo)
    allow(has_longitude).to receive(:validate)
      .with(hgeo)
  end

  it 'calls to HasField for h-geo' do
    expect(has_geo).to receive(:validate)
      .with(hevent)

    sut.validate(hevent)
  end

  it 'verifies h-geo.p-latitude' do
    expect(has_latitude).to receive(:validate)
      .with(hgeo)

    sut.validate(hevent)
  end

  it 'verifies h-geo.p-longitude' do
    expect(has_longitude).to receive(:validate)
      .with(hgeo)

    sut.validate(hevent)
  end
end
