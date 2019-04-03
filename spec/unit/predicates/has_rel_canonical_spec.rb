require 'spec_helper'

describe 'HasRelCanonical' do
  let(:sut) { ::HasRelCanonical.new }
  let(:page) { double }

  context 'when not found' do
    it 'Raises InvalidMetadataError' do
      rels = {}

      expect(page).to receive(:rels)
        .and_return rels

      expect {sut.validate(page)}.to raise_error(InvalidMetadataError, 'No Canonical URL found')
    end
  end

  context 'when found' do
    it 'does not error' do
      # given
      rels = {
        canonical: [
          'http://rabble'
        ]
      }

      expect(page).to receive(:rels)
        .and_return rels

      # when
      sut.validate(page)

      # then
      # no error
    end
  end
end
