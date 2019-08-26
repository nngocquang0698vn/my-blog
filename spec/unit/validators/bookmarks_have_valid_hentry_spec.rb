require 'spec_helper'

describe 'BookmarksHaveValidHentry' do
  context 'when on a bookmarks page' do
    context 'with content' do
      it 'checks the content is not empty' do
        html = Nokogiri::HTML(File.read('spec/fixtures/bookmark/with_content.html'))
        sut = BookmarksHaveValidHentry.new

        expect_any_instance_of(::HasUbookmarkof).to receive(:validate)
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

    context 'with a title' do
      it 'checks the title is not empty' do
        html = Nokogiri::HTML(File.read('spec/fixtures/bookmark/with_title.html'))
        sut = BookmarksHaveValidHentry.new

        expect_any_instance_of(::HasUbookmarkof).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasPName).to receive(:validate)
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

    context 'with neither content or title' do
      it 'does not throw errors' do
        html = Nokogiri::HTML(File.read('spec/fixtures/bookmark/without_content_title.html'))
        sut = BookmarksHaveValidHentry.new

        expect_any_instance_of(::HasUbookmarkof).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasUDateTimePublished).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasPcategory).to receive(:validate)
          .and_call_original

        expect_any_instance_of(::HasPcontent).to_not receive(:validate)
        expect_any_instance_of(::HasPName).to_not receive(:validate)

        ret = sut.validate(html)

        # no error
        expect(ret).to eq true
      end
    end

    context 'with no category' do
      it 'does not throw errors' do
        html = Nokogiri::HTML(File.read('spec/fixtures/bookmark/no_category.html'))
        sut = BookmarksHaveValidHentry.new

        expect_any_instance_of(::HasPcategory).to_not receive(:validate)
          .and_call_original

        ret = sut.validate(html)

        # no error
        expect(ret).to eq true
      end
    end

    context 'if any check fails' do
      it 'throws the error' do
        html = Nokogiri::HTML(File.read('spec/fixtures/bookmark/without_content_title.html'))
        sut = BookmarksHaveValidHentry.new

        expect_any_instance_of(::HasUbookmarkof).to receive(:validate)
          .and_raise InvalidMetadataError, 'Foo'

        expect { sut.validate(html) }.to raise_error(InvalidMetadataError, 'Foo')
      end
    end
  end

  pending 'no h-entry'

  context 'when the page does not have a bookmark-of' do
    it 'is skipped' do
      html = Nokogiri::HTML(File.read('spec/fixtures/reply/with_content.html'))
      sut = BookmarksHaveValidHentry.new

      ret = sut.validate(html)

      expect(ret).to eq false
    end
  end
end
