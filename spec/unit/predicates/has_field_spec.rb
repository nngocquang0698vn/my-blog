require 'spec_helper'

describe 'HasField' do
  context '`@fail_if_field_not_found` is true' do
    let(:sut) { HasField.new(:name, 'FooBar').fail_if_field_not_found(true) }
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

  context '`@fail_if_field_not_found` is false' do
    let(:sut) { HasField.new(:name, 'FooBar').fail_if_field_not_found(false) }
    let(:hentry) { double }

    it 'does not throw if field is not found' do
      expect(hentry).to receive(:respond_to?)
        .with(:name)
        .and_return false

      expect { sut.validate(hentry)}.to_not raise_error
    end
  end

  context '`@fail_if_field_not_found` is not set' do
    let(:sut) { HasField.new(:name, 'FooBar') }
    let(:hentry) { double }

    it 'defaults to `true`' do
      expect(hentry).to receive(:respond_to?)
        .with(:name)
        .and_return false

      expect { sut.validate(hentry)}.to raise_error(InvalidMetadataError, 'FooBar is not set')
    end
  end
end
