require 'spec_helper'

describe 'RsvpsHaveValidHentry' do
  let(:valid_filename) { './public/rsvps/0bdeb5b7-24fa-4bae-93ea-17b57eafbdf3/index.html' }

  context 'when on a rsvps page' do
    context 'with content' do
      it 'checks the content is not empty' do
        html = Nokogiri::HTML(File.read('spec/fixtures/rsvp/with_content.html'))
        sut = RsvpsHaveValidHentry.new('', valid_filename, html, {})

        expect_any_instance_of(::HasUinreplyto).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasUDateTimePublished).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasPrsvp).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasPcontent).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasPcategory).to receive(:validate)
          .and_call_original

        sut.run

        expect(sut.issues.length).to eq 0
      end
    end

    context 'with no content' do
      it 'does not throw errors' do
        html = Nokogiri::HTML(File.read('spec/fixtures/rsvp/without_content.html'))
        sut = RsvpsHaveValidHentry.new('', valid_filename, html, {})

        expect_any_instance_of(::HasUinreplyto).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasUDateTimePublished).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasPrsvp).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasPcategory).to receive(:validate)
          .and_call_original

        expect_any_instance_of(::HasPcontent).to_not receive(:validate)

        sut.run

        expect(sut.issues.length).to eq 0
      end
    end

    context 'if any check fails' do
      it 'calls to `add_issue`' do
        html = Nokogiri::HTML(File.read('spec/fixtures/rsvp/without_content.html'))
        sut = RsvpsHaveValidHentry.new('', valid_filename, html, {})

        expect_any_instance_of(::HasUinreplyto).to receive(:validate)
          .and_raise InvalidMetadataError, 'Foo'
        expect(sut).to receive(:add_issue)
          .with('Foo')
          .and_call_original

        sut.run

        expect(sut.issues.length).to eq 1
      end
    end
  end

  pending 'no h-entry'

  context 'when not on a rsvps page' do
    it 'is skipped' do
      html = Nokogiri::HTML(File.read('spec/fixtures/reply/with_content.html'))
      sut = RsvpsHaveValidHentry.new('', './public/reply/foo/', html, {})

      expect(Microformats).to_not receive(:parse)

      sut.run
    end
  end

  context 'when not on a rsvps page' do
    it 'is skipped' do
      html = Nokogiri::HTML(File.read('spec/fixtures/rsvp/without_content.html'))
      sut = RsvpsHaveValidHentry.new('', './public/rsvps/index.html', html, {})

      expect(Microformats).to_not receive(:parse)

      sut.run
    end
  end

  context 'when on a pagination page' do
    it 'is skipped' do
      html = Nokogiri::HTML(File.read('spec/fixtures/rsvp/without_content.html'))
      sut = RsvpsHaveValidHentry.new('', './public/rsvps/1/index.html', html, {})

      expect(Microformats).to_not receive(:parse)

      sut.run
    end
  end
end
