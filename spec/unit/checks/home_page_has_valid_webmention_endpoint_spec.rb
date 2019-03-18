require 'spec_helper'
require 'nokogiri'

describe 'HomePageHasValidWebmentionEndpoint' do
  context 'with no endpoint' do
    let(:html) { Nokogiri::HTML(File.read('spec/fixtures/invalid_webmention_data.html')) }
    let(:sut) { HomePageHasValidWebmentionEndpoint.new('', './public/index.html', html, {}) }

    it 'adds an issue' do
      wm = double('ValidWebmentionEndpoint')
      allow(::ValidWebmentionEndpoint).to receive(:new)
        .and_return wm
      allow(wm).to receive(:validate)
        .and_raise InvalidWebmentionEndpointError, 'Invalid Webmention endpoint'

      expect(sut).to receive(:add_issue)
        .with('Invalid Webmention endpoint')
        .and_call_original

      sut.run

      expect(sut.issues.length).to eq 1
    end
  end

  context 'with a valid endpoint' do
    let(:html) { Nokogiri::HTML(File.read('spec/fixtures/valid_webmention_data.html')) }
    let(:sut) { HomePageHasValidWebmentionEndpoint.new('', './public/index.html', html, {}) }

    it 'does not add an issue' do
      wm = double('ValidWebmentionEndpoint')
      allow(::ValidWebmentionEndpoint).to receive(:new)
        .and_return wm
      allow(wm).to receive(:validate)
        .and_return nil

      sut.run

      # no errors
      expect(sut.issues.length).to be_zero
    end
  end

  context 'when not on the home page' do
    let(:html) { Nokogiri::HTML(File.read('spec/fixtures/invalid_webmention_data.html')) }
    let(:sut) { HomePageHasValidWebmentionEndpoint.new('', './public/directory.html', html, {}) }

    it 'does nothing' do
      expect(sut).to_not receive(:add_issue)
      expect(::ValidWebmentionEndpoint).to_not receive(:new)

      # when
      sut.run

    end
  end
end
