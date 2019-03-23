require 'spec_helper'

describe 'EventHasHcardInPlocation' do
  let(:has_plocation) { double('HasField(:location, \'Location\')') }
  let(:plocation_is_hcard) { double('CardIsOfType(\'h-card\')') }
  let(:has_street_address) { double('HasPStreetAddress') }
  let(:has_locality) { double('HasPLocality') }
  let(:has_country_name) { double('HasPCountryName') }
  let(:has_postal_code) { double('HasPPostalCode') }

  let(:has_latitude) { double('HasPLatitude') }
  let(:has_longitude) { double('HasPLongitude') }

  let(:sut) { EventHasHcardInPlocation.new(has_plocation, plocation_is_hcard, has_street_address, has_locality, has_country_name, has_postal_code, has_latitude, has_longitude) }
  let(:hevent) { double }
  let(:hcard) { double }

  before :each do
    allow(hevent).to receive(:location)
      .and_return hcard

    allow(has_plocation).to receive(:validate)
      .with(hevent)

    allow(plocation_is_hcard).to receive(:validate)
      .with(hcard)

    [has_street_address, has_locality, has_country_name, has_postal_code].each do |p|
      allow(p).to receive(:validate)
      .with(hcard)
    end

    [has_latitude, has_longitude].each do |p|
      allow(p).to receive(:validate)
      .with(hcard)
    end
  end

  it 'calls to HasField for h-card' do
    expect(has_plocation).to receive(:validate)
      .with(hevent)

    sut.validate(hevent)
  end

  it 'calls to CardIsOfType for p-location' do
    expect(plocation_is_hcard).to receive(:validate)
      .with(hcard)

    sut.validate(hevent)
  end


  it 'verifies h-geo.p-latitude' do
    expect(has_latitude).to receive(:validate)
      .with(hcard)

    sut.validate(hevent)
  end

  it 'verifies h-geo.p-longitude' do
    expect(has_longitude).to receive(:validate)
      .with(hcard)

    sut.validate(hevent)
  end

  it 'verifies h-adr.p-street-address' do
    expect(has_street_address).to receive(:validate)
      .with(hcard)

    sut.validate(hevent)
  end

  it 'verifies h-adr.p-locality' do
    expect(has_locality).to receive(:validate)
      .with(hcard)

    sut.validate(hevent)
  end

  it 'verifies h-adr.p-country-name' do
    expect(has_country_name).to receive(:validate)
      .with(hcard)

    sut.validate(hevent)
  end

  it 'verifies h-adr.p-postal-code' do
    expect(has_postal_code).to receive(:validate)
      .with(hcard)

    sut.validate(hevent)
  end
end
