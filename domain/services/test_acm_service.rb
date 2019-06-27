require "minitest/autorun"
require_relative "acm_service.rb"

describe ACMService do
  describe "获取url" do
    it "无需要编码的字符" do
      url = "http://127.0.0.1:8080/diamond-server/config.co?tenant=1&group=2&dataId=3"
      ACMService.new.generate_url("127.0.0.1", "1", "2", "3").must_equal url
    end

    it "有需要编码的字符" do
      url = "http://127.0.0.1:8080/diamond-server/config.co?tenant=1+1&group=2%262&dataId=3.3"
      ACMService.new.generate_url("127.0.0.1", "1 1", "2&2", "3.3").must_equal url
    end
  end

  describe "签名" do
    it "正常签名" do
      service = ACMService.new
      sign = service.sign("1", "2", "3", "4")
      sign.wont_be_nil
    end
  end

  describe "获取配置" do
    it "正确获取配置" do
      service = ACMService.new
      config = service.get_config("T2HUT", "cipher-t2hut.service.point")
      config.wont_be_nil
    end
  end
end