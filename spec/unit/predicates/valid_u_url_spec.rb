require 'spec_helper'

describe 'ValidUUrl' do
  let(:hcard) { double('hcard') }
  let(:sut) { ValidUUrl.new }

  before :each do
    allow(hcard).to receive(:respond_to?)
      .with(:url)
      .and_return true
  end

  it 'throws if no u-url' do
    # given
    allow(hcard).to receive(:respond_to?)
      .with(:url)
      .and_return false

    # when
    expect { sut.validate(hcard)}.to raise_error(InvalidMetadataError, 'URL is not set')
  end

  it 'does not throw if no trailing slash' do
    # given
    expect(hcard).to receive(:url)
      .and_return 'https://www.jvt.me'

    # when
    sut.validate(hcard)

    # then
    # no error
  end

  it 'does not throw if trailing slash' do
    # given
    expect(hcard).to receive(:url)
      .and_return 'https://www.jvt.me/'

    # when
    sut.validate(hcard)

    # then
    # no error
  end

  it 'throws if URL is not mine' do
    # given
    expect(hcard).to receive(:url)
      .and_return 'https://spectat.me/'

    # when
    expect { sut.validate(hcard)}.to raise_error(InvalidMetadataError, 'URL is not equal to https://www.jvt.me')

    # then
  end
end
