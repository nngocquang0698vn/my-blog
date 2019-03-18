require_relative '../../../lib/predicates/valid_webmention_endpoint'

describe 'ValidWebmentionEndpoint' do
  let(:sut) { ValidWebmentionEndpoint.new }

  context 'when nil' do
    it 'throws' do
      expect { sut.validate(nil)}.to raise_error(InvalidWebmentionEndpointError, 'Webmention endpoint is not https://webmention.io/www.jvt.me/webmention')
    end
  end

  context 'when empty' do
    it 'throws' do
      expect { sut.validate('')}.to raise_error(InvalidWebmentionEndpointError, 'Webmention endpoint is not https://webmention.io/www.jvt.me/webmention')
    end
  end

  context 'when different end of string ' do
    it 'throws' do
      expect { sut.validate('https://webmention.io/www.jvt.me/webmentions')}.to raise_error(InvalidWebmentionEndpointError, 'Webmention endpoint is not https://webmention.io/www.jvt.me/webmention')
    end
  end

  context 'when valid' do
    it 'does not throw' do
      sut.validate('https://webmention.io/www.jvt.me/webmention')

      # no error
    end
  end
end
