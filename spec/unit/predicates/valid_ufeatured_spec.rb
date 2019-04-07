require 'spec_helper'

describe 'ValidUfeatured' do
  let(:sut) { ValidUfeatured.new(has_featured) }
  let(:hentry) { double }
  let(:has_featured) { double('HasUfeatured') }

  before :each do
    allow(has_featured).to receive(:validate)
      .with(hentry)
    allow(hentry).to receive(:featured)
      .and_return 'https://www.jvt.me/img/foo.png'
  end

  it 'delegates to HasUfeatured' do
    expect(has_featured).to receive(:validate)
      .with(hentry)

    sut.validate(hentry)
  end

  it 'throws if u-featured does not start with site image path' do
    expect(hentry).to receive(:featured)
      .and_return 'http://jvt.me/posts/img/foo.png'

    expect { sut.validate(hentry) }.to raise_error(InvalidMetadataError, 'Featured image does not start with https://www.jvt.me/img/')
  end

  it 'does not throw if u-featured starts with site image path' do
    expect(hentry).to receive(:featured)
      .and_return 'https://www.jvt.me/img/foo.png'

    sut.validate(hentry)

    # no error
  end
end
