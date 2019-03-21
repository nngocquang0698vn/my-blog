require 'spec_helper'

describe 'HasHAdr' do
  let(:has_address) { double('HasField(:adr, \'Address\')') }
  let(:has_street_address) { double('HasPStreetAddress') }
  let(:has_locality) { double('HasPLocality') }
  let(:has_country_name) { double('HasPCountryName') }
  let(:has_postal_code) { double('HasPPostalCode') }

  let(:sut) { HasHAdr.new(has_address, has_street_address, has_locality, has_country_name, has_postal_code) }
  let(:hevent) { double }
  let(:hadr) { double }

  before :each do
    allow(has_address).to receive(:validate)
      .with(hevent)
    allow(hevent).to receive(:adr)
      .and_return hadr

    [has_street_address, has_locality, has_country_name, has_postal_code].each do |p|
      allow(p).to receive(:validate)
      .with(hadr)
    end
  end

  it 'calls to HasField for h-adr' do
    expect(has_address).to receive(:validate)
      .with(hevent)

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
