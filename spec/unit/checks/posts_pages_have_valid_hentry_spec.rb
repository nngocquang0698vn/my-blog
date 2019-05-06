require 'spec_helper'

describe 'PostsPagesHaveValidHentry' do
  context 'on a blog post' do
    context 'with no h-entry' do
      let(:html) { Nokogiri::HTML(File.read('spec/fixtures/post_no_hentry.html')) }
      let(:sut) { PostsPagesHaveValidHentry.new('', './public/posts/2018/10/20/abc/index.html', html, {})}

      it 'adds an issue' do
        expect(sut).to receive(:add_issue)
          .with('No h-entry found')
          .and_call_original

        sut.run

        expect(sut.issues.length).to eq 1
      end
    end

    context 'with multiple h-entry' do
      let(:html) { Nokogiri::HTML(File.read('spec/fixtures/post_multiple_hentry.html')) }
      let(:sut) { PostsPagesHaveValidHentry.new('', './public/posts/2018/10/20/abc/index.html', html, {})}

      it 'adds an issue' do
        expect(sut).to receive(:add_issue)
          .with('Multiple h-entry found')
          .and_call_original

        sut.run

        expect(sut.issues.length).to eq 1
      end
    end

    context 'with a single h-entry' do
      let(:html) { Nokogiri::HTML(File.read('spec/fixtures/post_one_hentry.html')) }
      let(:sut) { PostsPagesHaveValidHentry.new('', './public/posts/2018/10/20/abc/index.html', html, {})}

      it 'does not throw if everything is well formed' do
        [::HasUDateTimePublished, ::HasUDateTimeUpdated, ::HasPSummary, ::HasEContent, ::HasUUrl, ::ValidPostUUrl, ::HasPName, ::ValidPauthor, ::HasPcategory, ::ValidUfeatured] .each do |clazz|
          # do nothing
          expect_any_instance_of(clazz).to receive(:validate)
            .and_return nil
        end

        expect_any_instance_of(::ValidUuid).to receive(:validate)
          # .with(...)

        sut.run

        expect(sut.issues.length).to be_zero
      end

      it 'calls add_issue if any validation errors occur' do
        expect_any_instance_of(::HasUDateTimePublished).to receive(:validate)
          .and_raise InvalidMetadataError, 'Wibble is not set'
        expect_any_instance_of(::HasEContent).to receive(:validate)
          .and_raise InvalidMetadataError, 'Contents of the post are not set'
        expect_any_instance_of(::ValidUuid).to receive(:validate)
          .and_raise InvalidMetadataError, 'This is an invalid uuid'

        expect(sut).to receive(:add_issue)
          .with('Wibble is not set')
          .and_call_original
        expect(sut).to receive(:add_issue)
          .with('Contents of the post are not set')
          .and_call_original
        expect(sut).to receive(:add_issue)
          .with('This is an invalid uuid')
          .and_call_original

        sut.run

        expect(sut.issues.length).to eq 3
      end
    end
  end

  context 'when not on a blog post' do
    let(:html) { Nokogiri::HTML(File.read('spec/fixtures/post_no_hentry.html')) }
    let(:sut) { PostsPagesHaveValidHentry.new('', './public/tags/chef/index.html', html, {})}

    it 'skips' do
      expect(sut).to_not receive(:add_issue)

      sut.run
    end
  end
end
