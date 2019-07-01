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
  def self.get(url, headers = nil)
    uri = URI(url)
    http = HTTPClient.http_class.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'
    response = http.get(uri, headers)

    result = response == nil ? HTTPResponse.new(404, nil, nil) : 
              HTTPResponse.new(response.code.to_i, response.body, response.to_hash)
  end

  def self.http_class
    @http_class || Net::HTTP
  end
end