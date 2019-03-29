require 'spec_helper'

describe 'PostsPagesHaveSyndicationLink' do
  context 'when #syndication-targets is found' do
    context 'with elements' do
      it 'does not error' do
        html = Nokogiri::HTML(File.read('spec/fixtures/post_syndication.html'))
        sut = PostsPagesHaveSyndicationLink.new('', './public/posts/2018/10/20/abc/index.html', html, {})

        expect(sut).to_not receive(:add_issue)

        sut.run

        expect(sut.issues.length).to eq 0
      end
    end

    context 'but empty' do
      it 'errors' do
        html = Nokogiri::HTML(File.read('spec/fixtures/post_no_links_in_syndication.html'))
        sut = PostsPagesHaveSyndicationLink.new('', './public/posts/2018/10/20/abc/index.html', html, {})

        expect(sut).to receive(:add_issue)
          .with('No u-syndication links found')
          .and_call_original

        sut.run

        expect(sut.issues.length).to eq 1
      end
    end
  end

  context 'when #syndication-targets is not found' do
    it 'does not error' do
      html = Nokogiri::HTML(File.read('spec/fixtures/post_no_syndication.html'))
      sut = PostsPagesHaveSyndicationLink.new('', './public/posts/2018/10/20/abc/index.html', html, {})

      expect(sut).to_not receive(:add_issue)

      sut.run

      expect(sut.issues.length).to eq 0
    end
  end
end
