require 'spec_helper'

describe 'HasHAdr' do
  let(:has_plocation) { double('HasField(:location, \'Location\')') }
  let(:plocation_is_hadr) { double('CardIsOfType(\'h-adr\')') }
  let(:has_street_address) { double('HasPStreetAddress') }
  let(:has_locality) { double('HasPLocality') }
  let(:has_country_name) { double('HasPCountryName') }
  let(:has_postal_code) { double('HasPPostalCode') }

  let(:sut) { HasHAdr.new(has_plocation, plocation_is_hadr, has_street_address, has_locality, has_country_name, has_postal_code) }
  let(:hevent) { double }
  let(:hadr) { double }

  before :each do
    allow(hevent).to receive(:location)
      .and_return hadr
    allow(has_plocation).to receive(:validate)
      .with(hevent)

    [plocation_is_hadr, has_street_address, has_locality, has_country_name, has_postal_code].each do |p|
      allow(p).to receive(:validate)
      .with(hadr)
    end
  end

  it 'calls to HasField for h-adr' do
    expect(has_plocation).to receive(:validate)
      .with(hevent)

    sut.validate(hevent)
  end

  it 'calls to CardIsOfType for p-location' do
    expect(plocation_is_hadr).to receive(:validate)
      .with(hadr)

    sut.validate(hevent)
  end

  it 'verifies h-adr.p-street-address' do
    expect(has_street_address).to receive(:validate)
      .with(hadr)

    sut.validate(hevent)
  end

  it 'verifies h-adr.p-locality' do
    expect(has_locality).to receive(:validate)
      .with(hadr)

    sut.validate(hevent)
  end

  it 'verifies h-adr.p-country-name' do
    expect(has_country_name).to receive(:validate)
      .with(hadr)

    sut.validate(hevent)
  end

  it 'verifies h-adr.p-postal-code' do
    expect(has_postal_code).to receive(:validate)
      .with(hadr)

    sut.validate(hevent)
  end
end
