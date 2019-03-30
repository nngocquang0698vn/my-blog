require 'spec_helper'

describe 'HasRel' do
  let(:sut) { HasRel.new(:authorization_endpoint, 'authorization_endpoint') }
  let(:page) { double }

  context 'when the rel is found' do
    context 'as a string key' do
      context 'and non-zero in length' do
        it 'does not error' do
          h = {}
          h['authorization_endpoint'] = ['another_value']

          expect(page).to receive(:rels)
            .and_return h

          sut.validate(page)
        end
      end
    end

    context 'but is an empty array' do
      it 'raises InvalidMetadataError' do
        h = {
          authorization_endpoint: [
          ]
        }

        expect(page).to receive(:rels)
          .and_return h

        expect{ sut.validate(page)}.to raise_error(InvalidMetadataError, 'No authorization_endpoint found')
      end
    end

    context 'but is an empty string' do
      it 'raises InvalidMetadataError' do
        h = {
          authorization_endpoint: [
            ''
          ]
        }

        expect(page).to receive(:rels)
          .and_return h

        expect{ sut.validate(page)}.to raise_error(InvalidMetadataError, 'No authorization_endpoint found')
      end
    end

    context 'and non-zero in length' do
      it 'does not error' do
        h = {
          authorization_endpoint: [
            'value'
          ]
        }

        expect(page).to receive(:rels)
          .and_return h

        sut.validate(page)
      end
    end
  end

  context 'when the rel is not found' do
    it 'raises InvalidMetadataError' do
      h = {
      }

      expect(page).to receive(:rels)
        .and_return h

      expect{ sut.validate(page)}.to raise_error(InvalidMetadataError, 'No authorization_endpoint found')
    end
  end
end
