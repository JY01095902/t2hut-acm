require "minitest/autorun"
require_relative "http_client.rb"

class FakeHTTPResponse
  attr_reader :code
  attr_reader :body
  
  def initialize(code, body = nil)
    @code = code
    @body = body
  end
  
  def to_hash
  end
end

describe HTTPClient do
  describe "调用get方法" do
    it "正确路径，应该成功" do
      class FakeHTTP
        attr_writer :use_ssl
        def initialize(url, port) ; end
        def get(uri, headers)
          FakeHTTPResponse.new("200", "It's OK!")
        end
      end
      HTTPClient.instance_eval { @http_class = FakeHTTP }

      response = HTTPClient.get("https://test.example.com/books")
      response.status_code.must_equal 200
      response.body.must_equal "It's OK!"
    end
    it "错误路径，应该失败" do
      class FakeHTTP
        attr_writer :use_ssl
        def initialize(url, port) ; end
        def get(uri, headers)
          FakeHTTPResponse.new("500", "Some errors!")
        end
      end
      HTTPClient.instance_eval { @http_class = FakeHTTP }
      
      response = HTTPClient.get("https://test.example.com/books")
      response.status_code.must_equal 500
      response.body.must_equal "Some errors!"
    end
    it "错误路径（http请求返回结果为空），应该返回404" do
      class FakeHTTP
        attr_writer :use_ssl
        def initialize(url, port) ; end
        def get(uri, headers)
          nil
        end
      end
      HTTPClient.instance_eval { @http_class = FakeHTTP }
      
      response = HTTPClient.get("https://test.example.com/books")
      response.status_code.must_equal 404
      response.body.must_be_nil
    end
  end
end