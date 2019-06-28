require "minitest/autorun"
require_relative "encryption_service.rb"

describe EncryptionService do
  describe "解密" do
    it "正常解密" do
      service = EncryptionService.new
      config = service.decrypt("Y2Q2OTFlZmMtNDc5MC00NzQzLTg5ZGItZDIyYTBiOGRkYTQxdzIwZ1ZpV2dEVWc2UFNBQ1ozMWl3V2JsZE5XeUhDUG5BQUFBQUFBQUFBQ1JOQ0J5aG8zNzMyWk1ucWoxUStVU25ENzRCdS9NWDNiMjAwWlA1RUVvSHhsV1VER2hoTDhpckdncHZPcm4zMjFOdjhUVVo3Z0lmZlBtNkNCSnRxZVdGZTV4eGoxUTFnPT0=")
      config.wont_be_nil
    end
    it "错误解密" do
      service = EncryptionService.new
      config = service.decrypt("Y2Q2OTF")
      config.must_be_nil
    end
  end
end