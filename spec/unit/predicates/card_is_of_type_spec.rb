require 'spec_helper'

describe 'CardIsOfType' do
  context 'when card is of type' do
    let(:sut) { CardIsOfType.new('h-adr') }
    let(:card) { double }

    it 'returns true' do
      expect(card).to receive(:type)
        .and_return 'h-adr'

      expect(sut.validate(card)).to eq true
    end
  end

  context 'when card is not of type' do
    let(:sut) { CardIsOfType.new('h-wibble') }
    let(:card) { double }

    it 'raises InvalidMetadataError' do
      expect(card).to receive(:type)
        .and_return 'h-foo'

      expect{ sut.validate(card)}.to raise_error(InvalidMetadataError, 'card was not of type `h-wibble`, was `h-foo`')
    end
  end
end
