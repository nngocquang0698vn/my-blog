require 'spec_helper'

describe 'HomePageHasMicropubSettings' do
  context 'when on the home page' do
    context 'with micropub settings' do
      let(:html) { Nokogiri::HTML(File.read('spec/fixtures/home_page_with_micropub.html')) }
      let(:sut) { HomePageHasMicropubSettings.new('', './public/index.html', html, {}) }

      before :each do
        expect_any_instance_of(::HasMicropubEndpoint).to receive(:validate)
          .and_call_original
      end

      it 'does not error' do
        sut.run

        expect(sut.issues.length).to eq 0
      end
    end

    context 'without micropub settings' do
      let(:html) { Nokogiri::HTML(File.read('spec/fixtures/home_page_no_micropub.html')) }
      let(:sut) { HomePageHasMicropubSettings.new('', './public/index.html', html, {}) }

      before :each do
        expect_any_instance_of(::HasMicropubEndpoint).to receive(:validate)
          .and_call_original
      end

      it 'errors' do
        sut.run

        expect(sut.issues.length).to eq 1
      end
    end
  end

  context 'when not on the home page' do
    let(:html) { Nokogiri::HTML(File.read('spec/fixtures/home_page_no_micropub.html')) }
    let(:sut) { HomePageHasMicropubSettings.new('', './public/wibble.html', html, {}) }

    it 'does nothing' do
      expect(sut).to_not receive(:add_issue)
      expect(::Microformats).to_not receive(:parse)
      expect_any_instance_of(::HasMicropubEndpoint).to_not receive(:validate)

      # when
      sut.run

      expect(sut.issues.length).to be_zero
    end
  end
end
