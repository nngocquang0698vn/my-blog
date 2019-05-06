require 'spec_helper'

describe 'NotesHaveValidHentry' do
  let(:valid_filename) { './public/notes/a75020a9-1a4d-48b2-b76a-62e701d6fe70/index.html' }

  context 'when on a notes page' do
    context 'with a title' do
      it 'does not throw errors' do
        html = Nokogiri::HTML(File.read('spec/fixtures/note/with_title.html'))
        sut = NotesHaveValidHentry.new('', valid_filename, html, {})

        expect_any_instance_of(::HasPName).to receive(:validate)
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

    context 'without a title' do
      it 'does not throw errors' do
        html = Nokogiri::HTML(File.read('spec/fixtures/note/without_title.html'))
        sut = NotesHaveValidHentry.new('', valid_filename, html, {})

        expect_any_instance_of(::HasPcontent).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasUDateTimePublished).to receive(:validate)
          .and_call_original
        expect_any_instance_of(::HasPcategory).to receive(:validate)
          .and_call_original

        expect_any_instance_of(::HasPName).to_not receive(:validate)

        sut.run

        expect(sut.issues.length).to eq 0
      end
    end

    context 'if any check fails' do
      it 'calls to `add_issue`' do
        html = Nokogiri::HTML(File.read('spec/fixtures/note/without_title.html'))
        sut = NotesHaveValidHentry.new('', valid_filename, html, {})

        expect_any_instance_of(::HasPcontent).to receive(:validate)
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

  context 'when not on a notes page' do
    it 'is skipped' do
      html = Nokogiri::HTML(File.read('spec/fixtures/note/with_title.html'))
      sut = NotesHaveValidHentry.new('', './public/reply/foo/', html, {})

      expect(Microformats).to_not receive(:parse)

      sut.run
    end
  end

  context 'when on the top-level notes page' do
    it 'is skipped' do
      html = Nokogiri::HTML(File.read('spec/fixtures/note/without_title.html'))
      sut = NotesHaveValidHentry.new('', './public/notes/index.html', html, {})

      expect(Microformats).to_not receive(:parse)

      sut.run
    end
  end

  context 'when on a pagination page' do
    it 'is skipped' do
      html = Nokogiri::HTML(File.read('spec/fixtures/note/without_title.html'))
      sut = NotesHaveValidHentry.new('', './public/notes/1/index.html', html, {})

      expect(Microformats).to_not receive(:parse)

      sut.run
    end
  end
end
