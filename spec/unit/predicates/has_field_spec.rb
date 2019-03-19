require 'spec_helper'

describe 'HasField' do
  context 'When verifying p-name' do
    let(:sut) { HasField.new(:name, 'FooBar') }
    let(:hentry) { double }

    it 'does not throw if field is non-zero length' do
      expect(hentry).to receive(:respond_to?)
        .with(:name)
        .and_return true
      expect(hentry).to receive(:send)
        .with(:name)
        .and_return 'wibble'

      sut.validate(hentry)
    end

    it 'throws if field is empty string' do
      expect(hentry).to receive(:respond_to?)
        .with(:name)
        .and_return true
      expect(hentry).to receive(:send)
        .with(:name)
        .and_return ''

      expect { sut.validate(hentry)}.to raise_error(InvalidMetadataError, 'FooBar is not set')
    end

    it 'throws if field is nil' do
      expect(hentry).to receive(:respond_to?)
        .with(:name)
        .and_return true
      expect(hentry).to receive(:send)
        .with(:name)
        .and_return nil

      expect { sut.validate(hentry)}.to raise_error(InvalidMetadataError, 'FooBar is not set')
    end

    it 'throws if field is not found' do
      expect(hentry).to receive(:respond_to?)
        .with(:name)
        .and_return false

      expect { sut.validate(hentry)}.to raise_error(InvalidMetadataError, 'FooBar is not set')
    end
  end
end
