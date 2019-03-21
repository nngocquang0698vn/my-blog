require 'spec_helper'

describe 'EventsPagesHaveValidHevent' do
  context 'on an event' do
    context 'with an h-event' do
      context 'regardless of the p-location' do
        let(:html) { Nokogiri::HTML(File.read('spec/fixtures/event_plain_plocation.html')) }
        let(:sut) { EventsPagesHaveValidHevent.new('', '', html, {}) }

        it 'verifies there is a p-name' do
          predicate = double
          expect(::HasPName).to receive(:new)
            .and_return predicate
          expect(predicate).to receive(:validate)

          sut.run
        end

        it 'verifies there is a dt-start' do
          predicate = double
          expect(::HasDtStart).to receive(:new)
            .and_return predicate
          expect(predicate).to receive(:validate)

          sut.run
        end

        it 'verifies there is a dt-end' do
          predicate = double
          expect(::HasDtEnd).to receive(:new)
            .and_return predicate
          expect(predicate).to receive(:validate)

          sut.run
        end

        it 'verifies there is a p-location' do
          predicate = double
          expect(::HasPLocation).to receive(:new)
            .and_return predicate
          expect(predicate).to receive(:validate)

          sut.run
        end

        it 'verifies there is a p-summary' do
          predicate = double
          expect(::HasPSummary).to receive(:new)
            .and_return predicate
          expect(predicate).to receive(:validate)

          sut.run
        end

        it 'reports issues if any occur' do
          expect_any_instance_of(::HasDtStart).to receive(:validate)
            .and_raise(InvalidMetadataError, 'date not present')
          expect_any_instance_of(::HasPSummary).to receive(:validate)
            .and_raise(InvalidMetadataError, 'wibble foo')

          sut.run

          expect(sut.issues.length).to eq 2
        end
      end
    end
  end
end
