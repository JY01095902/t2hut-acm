require "net/https"
require "pp"

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
    def get(url, header)
        uri = URI(url)
        response = Net::HTTP.get_response(uri)

        return HTTPResponse.new(response.code, response.body, response.to_hash)
    end

    public :get
end

client = HTTPClient.new
url = "https://gateway.p2shop.com.cn/inventories-for-stk-api/api/v2/plants/EE-CDVQ/stocktaking-scheduled-dates?tenantCode=eland"
response = client.get(url, nil)

pp response