require 'spec_helper'

describe 'ValidPauthor' do
  let(:sut) { ValidPauthor.new }
  let(:entry) { double }
  let(:author) { double }

  before :each do
    allow(entry).to receive(:respond_to?)
      .with(:author)
      .and_return true
    allow(entry).to receive(:author)
      .and_return author

    allow(author).to receive(:url)
      .and_return 'https://www.jvt.me'
    allow(author).to receive(:name)
      .and_return 'Jamie Tanna'
  end

  it 'raises InvalidMetadataError if there is no author' do
    expect(entry).to receive(:respond_to?)
      .with(:author)
      .and_return false

    expect{ sut.validate(entry) }.to raise_error(InvalidMetadataError, 'No p-author found')
  end

  it 'calls to HasUUrl' do
    expect_any_instance_of(HasUUrl).to receive(:validate)
      .with(author)

    sut.validate(entry)
  end

  it 'calls to ValidUUrl' do
    expect_any_instance_of(ValidUUrl).to receive(:validate)
      .with(author)

    sut.validate(entry)
  end

  it 'calls to HasPName' do
    expect_any_instance_of(HasPName).to receive(:validate)
      .with(author)

    sut.validate(entry)
  end

  it 'calls to ValidPName' do
    expect_any_instance_of(ValidPName).to receive(:validate)
      .with(author)

    sut.validate(entry)
  end
end
