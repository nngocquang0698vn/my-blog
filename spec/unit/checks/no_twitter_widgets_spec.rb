require 'spec_helper'

describe 'NoTwitterWidgets' do
  context 'when Twitter widget is found' do
    it 'errors' do
      html = Nokogiri::HTML(File.read('spec/fixtures/twitter-widget/widget.html'))
      sut = NoTwitterWidgets.new('', './public/index.html', html, {})

      expect(sut).to receive(:add_issue)
        .with('Twitter widget found on the site - please remove it for privacy concerns')
        .and_call_original

      sut.run

      expect(sut.issues.length).to eq 1
    end
  end

  context 'when Twitter widget is not found' do
    it 'does not error' do
      html = Nokogiri::HTML(File.read('spec/fixtures/twitter-widget/no-widget.html'))
      sut = NoTwitterWidgets.new('', './public/index.html', html, {})

      expect(sut).to_not receive(:add_issue)

      sut.run

      expect(sut.issues.length).to eq 0
    end
  end

  context 'when <script> does not have a src tag' do
    it 'does not error' do
      html = Nokogiri::HTML(File.read('spec/fixtures/twitter-widget/no-src.html'))
      sut = NoTwitterWidgets.new('', './public/index.html', html, {})

      expect(sut).to_not receive(:add_issue)

      sut.run

      expect(sut.issues.length).to eq 0
    end
  end
end
