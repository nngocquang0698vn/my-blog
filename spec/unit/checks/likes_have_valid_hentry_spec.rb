require 'spec_helper'

describe 'LikesHaveValidHentry' do
  let(:valid_filename) { './public/likes/c0bb6cff-fc03-42d1-87d0-d817ad2f550f/index.html' }

  context 'when on a likes page' do
    context 'with valid like' do
      it 'does not throw errors' do
        html = Nokogiri::HTML(File.read('spec/fixtures/like/valid.html'))
        sut = LikesHaveValidHentry.new('', valid_filename, html, {})

        expect_any_instance_of(::HasUlikeof).to receive(:validate)
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
        html = Nokogiri::HTML(File.read('spec/fixtures/like/valid.html'))
        sut = LikesHaveValidHentry.new('', valid_filename, html, {})

        expect_any_instance_of(::HasUlikeof).to receive(:validate)
          .and_raise InvalidMetadataError, 'Bar'
        expect(sut).to receive(:add_issue)
          .with('Bar')
          .and_call_original


        sut.run

        expect(sut.issues.length).to eq 1
      end
    end
  end

  pending 'no h-entry'

  context 'when not on a likes page' do
    it 'is skipped' do
      html = Nokogiri::HTML(File.read('spec/fixtures/reply/with_content.html'))
      sut = LikesHaveValidHentry.new('', './public/bookmark/foo/', html, {})

      expect(Microformats).to_not receive(:parse)

      sut.run
    end
  end

  context 'when on the top-level likes page' do
    it 'is skipped' do
        html = Nokogiri::HTML(File.read('spec/fixtures/like/valid.html'))
        sut = LikesHaveValidHentry.new('', './public/likes/index.html', html, {})

      expect(Microformats).to_not receive(:parse)

      sut.run
    end
  end

  context 'when on a pagination page' do
    it 'is skipped' do
        html = Nokogiri::HTML(File.read('spec/fixtures/like/valid.html'))
        sut = LikesHaveValidHentry.new('', './public/likes/1/index.html', html, {})

      expect(Microformats).to_not receive(:parse)

      sut.run
    end
  end
end
