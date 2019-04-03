require 'spec_helper'

describe 'ValidUuid' do
  let(:has_rel_canonical) { double }
  let(:has_uuid) { double }
  let(:sut) { ::ValidUuid.new(has_rel_canonical, has_uuid) }
  let(:page_mf) { double }
  let(:entry) { double }
  let(:rels) { double }

  before :each do
    allow(has_rel_canonical).to receive(:validate)
      .with(page_mf)
    allow(has_uuid).to receive(:validate)
      .with(entry)

    allow(page_mf).to receive(:rels)
      .and_return rels
    allow(rels).to receive(:[])
      .with('canonical')
      .and_return ['http://wibble/foo']

    allow(entry).to receive(:uid)
      .and_return 'http://wibble/foo'
  end

  it 'verifies that it HasRelCanonical' do
    expect(has_rel_canonical).to receive(:validate)
      .with(page_mf)

    sut.validate(page_mf, entry)
  end

  it 'verifies that it HasRelCanonical' do
    expect(has_uuid).to receive(:validate)
      .with(entry)

    sut.validate(page_mf, entry)
  end

  context 'when rel=canonical does not match u-uid' do
    it 'raises an InvalidMetadataError' do
      expect(rels).to receive(:[])
        .with('canonical')
        .and_return ['https://wibble/foo']

      expect(entry).to receive(:uid)
        .and_return 'http://wibble/foo'

      expect { sut.validate(page_mf, entry) }.to raise_error(InvalidMetadataError, 'rel=canonical does not match u-uid')
    end
  end

  context 'when rel=canonical matches u-uid' do
    it 'does not error' do
      expect(rels).to receive(:[])
        .with('canonical')
        .and_return ['http://wibble/foo']

      expect(entry).to receive(:uid)
        .and_return 'http://wibble/foo'

      sut.validate(page_mf, entry)

      # no error
    end
  end
end
