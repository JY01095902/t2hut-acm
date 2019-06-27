require "net/https"

class HTTPResponse
  attr_reader :status_code
  attr_reader :body
  attr_reader :headers

  def initialize(status_code, body, headers)
    @status_code = status_code
    @body = body
    @headers = headers
  end
end

class HTTPClient
  def get(url, headers = nil)
    uri = URI(url)
    @http = Net::HTTP.new(uri.host, uri.port) if @http == nil
    @http.use_ssl = true if uri.scheme == 'https'
    response = @http.get(uri, headers)

    return HTTPResponse.new(response.code.to_i, response.body, response.to_hash)
  end
end