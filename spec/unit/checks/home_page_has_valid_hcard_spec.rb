require 'spec_helper'
require 'nokogiri'

describe 'HomePageHasValidHcard' do
  context 'with a single hcard' do
    let(:html) { Nokogiri::HTML(File.read('spec/fixtures/home_page_single_hcard.html')) }
    let(:sut) { HomePageHasValidHcard.new('', './public/index.html', html, {}) }

    it 'does not throw if everything is well formed' do
      [::HasJobDetails, ::ValidPLocality, ::ValidPName, ::ValidUEmail, ::ValidUPhoto, ::ValidUUrl].each do |clazz|
        expect(clazz).to receive(:new)
          .and_call_original
      end

      sut.run

      # no errors
      expect(sut.issues.length).to be_zero
    end

    it 'calls to `add_issue` if any validation errors thrown' do
      pname = double('ValidPName')
      allow(::ValidPName).to receive(:new)
        .and_return pname
      allow(pname).to receive(:validate)
        .and_raise InvalidMetadataError, 'Invalid p-name'

      uurl = double('ValidUUrl')
      allow(::ValidUUrl).to receive(:new)
        .and_return uurl
      allow(uurl).to receive(:validate)
        .and_raise InvalidMetadataError, 'Invalid URL, dummy!'

      expect(sut).to receive(:add_issue)
        .with('Invalid p-name')
        .and_call_original
      expect(sut).to receive(:add_issue)
        .with('Invalid URL, dummy!')
        .and_call_original

      sut.run

      expect(sut.issues.length).to eq 2
    end
  end

  context 'with zero hcards' do
    let(:html) { Nokogiri::HTML(File.read('spec/fixtures/home_page_zero_hcard.html')) }
    let(:sut) { HomePageHasValidHcard.new('', './public/index.html', html, {}) }

    it 'reports with `add_issue`' do
      expect(sut).to receive(:add_issue)
        .with('Zero h-cards can be found with ID `#jvt-hcard`')

      # when
      sut.run
    end
  end

  context 'when not on the home page' do
    let(:html) { Nokogiri::HTML(File.read('spec/fixtures/home_page_single_hcard.html')) }
    let(:sut) { HomePageHasValidHcard.new('', './public/wibble.html', html, {}) }

    it 'does not do anything' do
      expect(sut).to_not receive(:add_issue)
      expect(::Microformats).to_not receive(:parse)

      # when
      sut.run
    end
  end
end
