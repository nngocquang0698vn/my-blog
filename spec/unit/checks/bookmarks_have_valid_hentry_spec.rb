require 'spec_helper'

describe 'BookmarksHaveValidHentry' do
  let(:valid_filename) { './public/bookmarks/8586b94d-b349-4d22-97a9-675bfa59e079/index.html' }

  context 'when on a bookmarks page' do
    context 'with content' do
      it 'checks the content is not empty' do
        html = Nokogiri::HTML(File.read('spec/fixtures/bookmark/with_content.html'))
        sut = BookmarksHaveValidHentry.new('', valid_filename, html, {})

        expect_any_instance_of(::HasUbookmarkof).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasPcontent).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasUDateTimePublished).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasPcategory).to receive(:validate)
          .and_call_original

        sut.run

        expect(sut.issues.length).to eq 0
      end
    end

    context 'with a title' do
      it 'checks the title is not empty' do
        html = Nokogiri::HTML(File.read('spec/fixtures/bookmark/with_title.html'))
        sut = BookmarksHaveValidHentry.new('', valid_filename, html, {})

        expect_any_instance_of(::HasUbookmarkof).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasPName).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasUDateTimePublished).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasPcategory).to receive(:validate)
          .and_call_original

        sut.run

        expect(sut.issues.length).to eq 0
      end
    end

    context 'with neither content or title' do
      it 'does not throw errors' do
        html = Nokogiri::HTML(File.read('spec/fixtures/bookmark/without_content_title.html'))
        sut = BookmarksHaveValidHentry.new('', valid_filename, html, {})

        expect_any_instance_of(::HasUbookmarkof).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasUDateTimePublished).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasPcategory).to receive(:validate)
          .and_call_original

        expect_any_instance_of(::HasPcontent).to_not receive(:validate)
        expect_any_instance_of(::HasPName).to_not receive(:validate)

        sut.run

        expect(sut.issues.length).to eq 0
      end
    end

    context 'if any check fails' do
      it 'calls to `add_issue`' do
        html = Nokogiri::HTML(File.read('spec/fixtures/bookmark/without_content_title.html'))
        sut = BookmarksHaveValidHentry.new('', valid_filename, html, {})

        expect_any_instance_of(::HasUbookmarkof).to receive(:validate)
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

  context 'when not on a bookmarks page' do
    it 'is skipped' do
      html = Nokogiri::HTML(File.read('spec/fixtures/reply/with_content.html'))
      sut = BookmarksHaveValidHentry.new('', './public/reply/foo/', html, {})

      expect(Microformats).to_not receive(:parse)

      sut.run
    end
  end

  context 'when on a top-level bookmarks page' do
    it 'is skipped' do
      html = Nokogiri::HTML(File.read('spec/fixtures/bookmark/without_content_title.html'))
      sut = BookmarksHaveValidHentry.new('', './public/bookmarks/index.html', html, {})

      expect(Microformats).to_not receive(:parse)

      sut.run
    end
  end

  context 'when on a pagination page' do
    it 'is skipped' do
      html = Nokogiri::HTML(File.read('spec/fixtures/bookmark/without_content_title.html'))
      sut = BookmarksHaveValidHentry.new('', './public/bookmarks/1/index.html', html, {})

      expect(Microformats).to_not receive(:parse)

      sut.run
    end
  end
end
