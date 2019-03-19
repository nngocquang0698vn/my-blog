require 'spec_helper'

describe 'HasJobDetails' do
  let(:hcard) { double('hcard') }
  let(:sut) { HasJobDetails.new }
  let(:org) { double('org') }

  before :each do
    allow(hcard).to receive(:respond_to?)
      .with(:job_title)
      .and_return true
    allow(hcard).to receive(:job_title)
      .and_return 'something senior'

    allow(hcard).to receive(:respond_to?)
      .with(:org)
      .and_return true
    allow(hcard).to receive(:org)
      .and_return org
    allow(org).to receive(:respond_to?)
      .with(:url)
      .and_return true
    allow(org).to receive(:url)
      .and_return 'something'
    allow(org).to receive(:respond_to?)
      .with(:name)
      .and_return true
    allow(org).to receive(:name)
      .and_return 'else'
  end

  it 'does not error if p-job-title and p-org { u-url p-name }' do
    # given

    # when
    sut.validate(hcard)

    # then
    # no error
  end

  context 'errors when not set' do
    it 'p-job-title' do
      # given
      allow(hcard).to receive(:respond_to?)
        .with(:job_title)
        .and_return false

      # when
      expect { sut.validate(hcard) }.to raise_error(InvalidMetadataError, 'p-job-title not set')
    end

    it 'p-org' do
      # given
      allow(hcard).to receive(:respond_to?)
        .with(:org)
        .and_return false

      # when
      expect { sut.validate(hcard) }.to raise_error(InvalidMetadataError, 'p-org not set')
    end

    it 'p-org.p-name' do
      # given
      allow(org).to receive(:respond_to?)
        .with(:name)
        .and_return false

      # when
      expect { sut.validate(hcard) }.to raise_error(InvalidMetadataError, 'p-org.p-name not set')

      # then
    end

    it 'p-org.u-url' do
      # given
      allow(org).to receive(:respond_to?)
        .with(:url)
        .and_return false

      # when
      expect { sut.validate(hcard) }.to raise_error(InvalidMetadataError, 'p-org.u-url not set')
    end
  end

  context 'errors when empty' do
    it 'p-job-title' do
      # given
      allow(hcard).to receive(:job_title)
        .and_return ''

      # when
      expect { sut.validate(hcard) }.to raise_error(InvalidMetadataError, 'p-job-title not set')
    end

    it 'p-org.p-name' do
      # given
      allow(org).to receive(:name)
        .and_return ''

      # when
      expect { sut.validate(hcard) }.to raise_error(InvalidMetadataError, 'p-org.p-name not set')

      # then
    end

    it 'p-org.u-url' do
      # given
      allow(org).to receive(:url)
        .and_return ''

      # when
      expect { sut.validate(hcard) }.to raise_error(InvalidMetadataError, 'p-org.u-url not set')
    end
  end
end
