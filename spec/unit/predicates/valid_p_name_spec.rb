require_relative '../../../lib/predicates/valid_p_name'

describe 'ValidPName' do
  let(:hcard) { double('hcard') }
  let(:sut) { ValidPName.new }

  before :each do
    allow(hcard).to receive(:respond_to?)
      .with(:name)
      .and_return true
  end

  it 'throws if no p-name' do
    # given
    allow(hcard).to receive(:respond_to?)
      .with(:name)
      .and_return false

    # when
    expect { sut.validate(hcard)}.to raise_error(InvalidMetadataError, 'Name is not set')
  end

  it 'does not throw if correct name' do
    # given
    expect(hcard).to receive(:name)
      .and_return 'Jamie Tanna'

    # when
    sut.validate(hcard)

    # then
    # no error
  end

  it 'throws if URL is not mine' do
    # given
    expect(hcard).to receive(:name)
      .and_return 'James Tanna'

    # when
    expect { sut.validate(hcard)}.to raise_error(InvalidMetadataError, 'Name is not equal to Jamie Tanna')

    # then
  end
end

