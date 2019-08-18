require 'spec_helper'

describe 'RsvpsHaveValidHentry' do
  context 'when on a rsvps page' do
    context 'with content' do
      it 'checks the content is not empty' do
        html = Nokogiri::HTML(File.read('spec/fixtures/rsvp/with_content.html'))
        sut = RsvpsHaveValidHentry.new

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

        ret = sut.validate(html)

        # no error
        expect(ret).to eq true
      end
    end

    context 'with no content' do
      it 'does not throw errors' do
        html = Nokogiri::HTML(File.read('spec/fixtures/rsvp/without_content.html'))
        sut = RsvpsHaveValidHentry.new

        expect_any_instance_of(::HasUinreplyto).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasUDateTimePublished).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasPrsvp).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasPcategory).to receive(:validate)
          .and_call_original

        expect_any_instance_of(::HasPcontent).to_not receive(:validate)

        ret = sut.validate(html)

        # no error
        expect(ret).to eq true
      end
    end

    context 'if any check fails' do
      it 'throws the error' do
        html = Nokogiri::HTML(File.read('spec/fixtures/rsvp/without_content.html'))
        sut = RsvpsHaveValidHentry.new

        expect_any_instance_of(::HasUinreplyto).to receive(:validate)
          .and_raise InvalidMetadataError, 'Foo'

        expect { sut.validate(html) }.to raise_error(InvalidMetadataError, 'Foo')
      end
    end
  end

  pending 'no h-entry'

  context 'when no rsvp and in-reply-to' do
    it 'is skipped' do
      html = Nokogiri::HTML(File.read('spec/fixtures/reply/with_content.html'))
      sut = RsvpsHaveValidHentry.new

      ret = sut.validate(html)

      expect(ret).to eq false
    end
  end
end
