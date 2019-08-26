require 'spec_helper'

describe 'NotesHaveValidHentry' do
  context 'when on a notes page' do
    context 'with a title' do
      it 'does not throw errors' do
        html = Nokogiri::HTML(File.read('spec/fixtures/note/with_title.html'))
        sut = NotesHaveValidHentry.new

        expect_any_instance_of(::HasPName).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasPcontent).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasUDateTimePublished).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasPcategory).to receive(:validate)
          .and_call_original

        ret = sut.validate(html)

        # no error
        expect(ret).to eq true
      end
    end

    context 'without a title' do
      it 'does not throw errors' do
        html = Nokogiri::HTML(File.read('spec/fixtures/note/without_title.html'))
        sut = NotesHaveValidHentry.new

        expect_any_instance_of(::HasPcontent).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasUDateTimePublished).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasPcategory).to receive(:validate)
          .and_call_original

        expect_any_instance_of(::HasPName).to_not receive(:validate)

        ret = sut.validate(html)

        # no error
        expect(ret).to eq true
      end
    end

    context 'without categories' do
      it 'does not throw errors' do
        html = Nokogiri::HTML(File.read('spec/fixtures/note/without_category.html'))
        sut = NotesHaveValidHentry.new

        expect_any_instance_of(::HasPcategory).to_not receive(:validate)

        ret = sut.validate(html)

        # no error
        expect(ret).to eq true
      end
    end

    context 'if any check fails' do
      it 'calls to `add_issue`' do
        html = Nokogiri::HTML(File.read('spec/fixtures/note/without_title.html'))
        sut = NotesHaveValidHentry.new

        expect_any_instance_of(::HasPcontent).to receive(:validate)
          .and_raise InvalidMetadataError, 'Foo'

        expect { sut.validate(html) }.to raise_error(InvalidMetadataError, 'Foo')
      end
    end
  end

  pending 'no h-entry'

  pending 'way to determine what content type this is, other than via ordering'
end
