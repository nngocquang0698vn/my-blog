require 'spec_helper'

describe 'EventsPagesHaveSyndicationLink' do
  context 'when #syndication-targets is found' do
    context 'with elements' do
      it 'does not error' do
        html = Nokogiri::HTML(File.read('spec/fixtures/event_syndication.html'))
        sut = EventsPagesHaveSyndicationLink.new('', './public/events/this-is-a-123-post/2019/03/21/index.html', html, {})

        expect(sut).to_not receive(:add_issue)

        sut.run

        expect(sut.issues.length).to eq 0
      end
    end

    context 'but empty' do
      it 'errors' do
        html = Nokogiri::HTML(File.read('spec/fixtures/event_no_links_in_syndication.html'))
        sut = EventsPagesHaveSyndicationLink.new('', './public/events/this-is-a-123-post/2019/03/21/index.html', html, {})

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
      html = Nokogiri::HTML(File.read('spec/fixtures/event_no_syndication.html'))
      sut = EventsPagesHaveSyndicationLink.new('', './public/events/this-is-a-123-post/2019/03/21/index.html', html, {})

      expect(sut).to_not receive(:add_issue)

      sut.run

      expect(sut.issues.length).to eq 0
    end
  end
end
