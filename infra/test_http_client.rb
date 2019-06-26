require "minitest/autorun"
require_relative "http_client.rb"

# def get_response.fake_method
#   nil
# end

describe HTTPClient do
  describe "调用get方法" do
    it "正确路径，应该成功" do
      url = "https://gateway.p2shop.com.cn/inventories-for-stk-api/api/v2/plants/EE-CDVQ/stocktaking-scheduled-dates?tenantCode=eland"
      client = HTTPClient.new
      response = client.get(url)
      response.status_code.must_equal "200"
    end
  end
end