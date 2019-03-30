require 'spec_helper'

describe 'HomePageHasMicrosubSettings' do
  context 'when on the home page' do
    context 'with microsub settings' do
      let(:html) { Nokogiri::HTML(File.read('spec/fixtures/home_page_with_microsub.html')) }
      let(:sut) { HomePageHasMicrosubSettings.new('', './public/index.html', html, {}) }

      before :each do
        expect_any_instance_of(::HasMicrosubEndpoint).to receive(:validate)
          .and_call_original
      end

      it 'does not error' do
        sut.run

        expect(sut.issues.length).to eq 0
      end
    end

    context 'without microsub settings' do
      let(:html) { Nokogiri::HTML(File.read('spec/fixtures/home_page_no_microsub.html')) }
      let(:sut) { HomePageHasMicrosubSettings.new('', './public/index.html', html, {}) }

      before :each do
        expect_any_instance_of(::HasMicrosubEndpoint).to receive(:validate)
          .and_call_original
      end

      it 'errors' do
        sut.run

        expect(sut.issues.length).to eq 1
      end
    end
  end

  context 'when not on the home page' do
    let(:html) { Nokogiri::HTML(File.read('spec/fixtures/home_page_no_microsub.html')) }
    let(:sut) { HomePageHasMicrosubSettings.new('', './public/wibble.html', html, {}) }

    it 'does nothing' do
      expect(sut).to_not receive(:add_issue)
      expect(::Microformats).to_not receive(:parse)
      expect_any_instance_of(::HasMicrosubEndpoint).to_not receive(:validate)

      # when
      sut.run

      expect(sut.issues.length).to be_zero
    end
  end
end
