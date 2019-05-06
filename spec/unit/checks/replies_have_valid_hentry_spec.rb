require 'spec_helper'

describe 'RepliesHaveValidHentry' do
  let(:valid_filename) { './public/replies/350fc8ad-fa1d-4b09-800a-3f7fe1908cbc/index.html' }

  context 'when on a replies page' do
    context 'with content' do
      it 'checks the content is not empty' do
        html = Nokogiri::HTML(File.read('spec/fixtures/reply/with_content.html'))
        sut = RepliesHaveValidHentry.new('', valid_filename, html, {})

        expect_any_instance_of(::HasUinreplyto).to receive(:validate)
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

    context 'with no content' do
      it 'does not throw errors' do
        html = Nokogiri::HTML(File.read('spec/fixtures/reply/without_content.html'))
        sut = RepliesHaveValidHentry.new('', valid_filename, html, {})

        expect_any_instance_of(::HasUinreplyto).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasUDateTimePublished).to receive(:validate)
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
        html = Nokogiri::HTML(File.read('spec/fixtures/reply/without_content.html'))
        sut = RepliesHaveValidHentry.new('', valid_filename, html, {})

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

  context 'when not on a replies page' do
    it 'is skipped' do
      html = Nokogiri::HTML(File.read('spec/fixtures/reply/with_content.html'))
      sut = RepliesHaveValidHentry.new('', './public/bookmarks/foo/', html, {})

      expect(Microformats).to_not receive(:parse)

      sut.run
    end
  end

  context 'when on the top-level replies page' do
    it 'is skipped' do
      html = Nokogiri::HTML(File.read('spec/fixtures/reply/with_content.html'))
      sut = RepliesHaveValidHentry.new('', './public/replies/index.html', html, {})

      expect(Microformats).to_not receive(:parse)

      sut.run
    end
  end

  context 'when on a pagination page' do
    it 'is skipped' do
      html = Nokogiri::HTML(File.read('spec/fixtures/reply/with_content.html'))
      sut = RepliesHaveValidHentry.new('', './public/replies/1/index.html', html, {})

      expect(Microformats).to_not receive(:parse)

      sut.run
    end
  end
end
