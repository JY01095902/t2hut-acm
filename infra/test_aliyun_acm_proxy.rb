require "minitest/autorun"
require_relative "aliyun_acm_proxy.rb"

describe AliyunACMProxy do
  describe "创建的Aliyun ACM 代理是否有效 valid？" do
    it "环境变量T2HUT_ENV是dev或stg，应该返回true" do
      ENV["T2HUT_ENV"] = "dev"
      def AliyunACMProxy.get_server_ip(endpoint)
        return "http://127.0.0.1"
      end
      acm = AliyunACMProxy.new
      acm.valid? .must_equal true
    end
    it "环境变量T2HUT_ENV是stg，应该返回true" do
      ENV["T2HUT_ENV"] = "stg"
      def AliyunACMProxy.get_server_ip(endpoint)
        return "http://127.0.0.2"
      end
      acm = AliyunACMProxy.new
      acm.valid? .must_equal true
    end
    it "环境变量T2HUT_ENV是nil，应该返回false" do
      ENV["T2HUT_ENV"] = nil
      acm = AliyunACMProxy.new
      acm.valid? .must_equal false
    end
    it "环境变量T2HUT_ENV是xxx，应该返回false" do
      ENV["T2HUT_ENV"] = "xxx"
      acm = AliyunACMProxy.new
      acm.valid? .must_equal false
    end
  end
end