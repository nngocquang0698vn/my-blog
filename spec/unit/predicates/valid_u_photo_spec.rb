require_relative '../../../lib/predicates/valid_u_photo'

describe 'ValidUPhoto' do
  let(:hcard) { double('hcard') }
  let(:sut) { ValidUPhoto.new }

  before :each do
    allow(hcard).to receive(:respond_to?)
      .with(:photo)
      .and_return true
  end

  it 'throws if no p-locality' do
    # given
    allow(hcard).to receive(:respond_to?)
      .with(:photo)
      .and_return false

    # when
    expect { sut.validate(hcard)}.to raise_error(InvalidMetadataError, 'Photo is not set')
  end

  it 'does not throw if correct URL' do
    # given
    expect(hcard).to receive(:photo)
      .and_return 'https://www.jvt.me/img/profile.png'

    # when
    sut.validate(hcard)

    # then
    # no error
  end

  it 'throws if photo is not correct URL' do
    # given
    expect(hcard).to receive(:photo)
      .and_return 'https://www.jvt.me/img/profile.jpeg'

    # when
    expect { sut.validate(hcard)}.to raise_error(InvalidMetadataError, 'Photo is not equal to https://www.jvt.me/img/profile.png')

    # then
  end
end

