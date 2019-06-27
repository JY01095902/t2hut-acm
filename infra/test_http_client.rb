require "minitest/autorun"
require_relative "http_client.rb"

class FakeHTTPResponse
  attr_reader :code
  attr_reader :body
  
  def initialize(code, body)
    @code = code
    @body = body
  end
  
  def to_hash
  end
end
class FakeHTTP
  attr_writer :use_ssl

  def get(uri, headers)
    return FakeHTTPResponse.new(200, "It's OK!")
  end
end

describe HTTPClient do
  describe "调用get方法" do
    it "正确路径，应该成功" do
      url = "https://test.example.com/books"
      client = HTTPClient.new
      def client.http=(http)
        @http = http
      end
      client.http = FakeHTTP.new
      Time.stub :now, Time.at(0) do 
        response = client.get(url)
        response.status_code.must_equal 200
        response.body.must_equal "It's OK!"
      end
    end
  end
end