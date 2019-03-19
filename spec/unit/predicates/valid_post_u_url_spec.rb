require 'spec_helper'

describe 'ValidPostUUrl' do
  let(:hcard) { double }
  let(:sut) { ValidPostUUrl.new }

  it 'throws if URL does not start with site URL' do
    allow(hcard).to receive(:url)
      .and_return 'https://jvt.me/posts/wibble/foo.html'

    expect { sut.validate(hcard)}.to raise_error(InvalidMetadataError, 'Post URL does not match site URL')
  end

  it 'does not throw if URL starts with site URL' do
    allow(hcard).to receive(:url)
      .and_return 'https://www.jvt.me/posts/wibble/foo.html'

    sut.validate(hcard)

    # no error
  end
end
