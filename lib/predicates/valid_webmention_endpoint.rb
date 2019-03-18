require_relative '../invalid_webmention_endpoint_error'

class ValidWebmentionEndpoint
  VALID_URL = 'https://webmention.io/www.jvt.me/webmention'.freeze

  def validate(url)
    raise InvalidWebmentionEndpointError, "Webmention endpoint is not #{VALID_URL}" unless VALID_URL == url
  end
end
