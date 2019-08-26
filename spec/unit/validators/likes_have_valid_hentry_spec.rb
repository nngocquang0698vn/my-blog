require 'spec_helper'

describe 'LikesHaveValidHentry' do
  context 'when on a likes page' do
    context 'with valid like' do
      it 'does not throw errors' do
        html = Nokogiri::HTML(File.read('spec/fixtures/like/valid.html'))
        sut = LikesHaveValidHentry.new

        expect_any_instance_of(::HasUlikeof).to receive(:validate)
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
        html = Nokogiri::HTML(File.read('spec/fixtures/like/valid_no_category.html'))
        sut = LikesHaveValidHentry.new

        expect_any_instance_of(::HasPcategory).to_not receive(:validate)
          .and_call_original

        ret = sut.validate(html)

        # no error
        expect(ret).to eq true
      end
    end

    context 'if any check fails' do
      it 'throws the error' do
        html = Nokogiri::HTML(File.read('spec/fixtures/like/valid.html'))
        sut = LikesHaveValidHentry.new

        expect_any_instance_of(::HasUlikeof).to receive(:validate)
          .and_raise InvalidMetadataError, 'Bar'

        expect { sut.validate(html) }.to raise_error(InvalidMetadataError, 'Bar')
      end
    end
  end

  pending 'no h-entry'

  context 'when the page does not have a like-of' do
    it 'is skipped' do
      html = Nokogiri::HTML(File.read('spec/fixtures/reply/with_content.html'))
      sut = LikesHaveValidHentry.new

      ret = sut.validate(html)

      # no error
      expect(ret).to eq false
    end
  end
end
