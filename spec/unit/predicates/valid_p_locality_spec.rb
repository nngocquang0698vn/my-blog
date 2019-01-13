require_relative '../../../lib/predicates/valid_p_locality'

describe 'ValidPLocality' do
  let(:hcard) { double('hcard') }
  let(:sut) { ValidPLocality.new }

  before :each do
    allow(hcard).to receive(:respond_to?)
      .with(:locality)
      .and_return true
  end

  it 'does not throw if Nottingham' do
    # given
    expect(hcard).to receive(:locality)
      .and_return 'Nottingham'

    # when
    sut.validate(hcard)

    # then
    # no error
  end

  it 'throws if no p-locality' do
    # given
    allow(hcard).to receive(:respond_to?)
      .with(:locality)
      .and_return false

    # when
    expect { sut.validate(hcard)}.to raise_error(InvalidMetadataError, 'Locality is not set')
  end

  it 'throws if not Nottingham' do
    # given
    expect(hcard).to receive(:locality)
      .and_return 'Notts'

    # when
    expect { sut.validate(hcard)}.to raise_error(InvalidMetadataError, 'Locality is not Nottingham')
  end
end
