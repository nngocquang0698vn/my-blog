require 'spec_helper'

describe 'RepostsHaveValidHentry' do
  let(:valid_filename) { './public/reposts/d760ecdc-359b-4312-9269-2163ce1e135e/index.html' }

  context 'when on a reposts page' do
    context 'with content' do
      it 'checks the content is not empty' do
        html = Nokogiri::HTML(File.read('spec/fixtures/repost/with_content.html'))
        sut = RepostsHaveValidHentry.new('', valid_filename, html, {})

        expect_any_instance_of(::HasUrepostof).to receive(:validate)
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
        html = Nokogiri::HTML(File.read('spec/fixtures/repost/without_content.html'))
        sut = RepostsHaveValidHentry.new('', valid_filename, html, {})

        expect_any_instance_of(::HasUrepostof).to receive(:validate)
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
        html = Nokogiri::HTML(File.read('spec/fixtures/repost/without_content.html'))
        sut = RepostsHaveValidHentry.new('', valid_filename, html, {})

        expect_any_instance_of(::HasUrepostof).to receive(:validate)
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

  context 'when not on a reposts page' do
    it 'is skipped' do
      html = Nokogiri::HTML(File.read('spec/fixtures/repost/with_content.html'))
      sut = RepostsHaveValidHentry.new('', './public/replies/foo/', html, {})

      expect(Microformats).to_not receive(:parse)

      sut.run
    end
  end

  context 'when on the top-level reposts page ' do
    it 'is skipped' do
      html = Nokogiri::HTML(File.read('spec/fixtures/repost/without_content.html'))
      sut = RepostsHaveValidHentry.new('', './public/reposts/index.html', html, {})

      expect(Microformats).to_not receive(:parse)

      sut.run
    end
  end

  context 'when on a pagination page' do
    it 'is skipped' do
      html = Nokogiri::HTML(File.read('spec/fixtures/repost/without_content.html'))
      sut = RepostsHaveValidHentry.new('', './public/reposts/1/index.html', html, {})

      expect(Microformats).to_not receive(:parse)

      sut.run
    end
  end
end
