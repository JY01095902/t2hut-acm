require "minitest/autorun"
require_relative "config_app_service.rb"

describe ConfigAppService do
  describe "查询配置信息" do
    it "应该成功" do
      service = ConfigAppService.new
      config = service.get_config("BODLEIAN", "cipher-t2hut.service.point")
      config.wont_be_nil
      config.must_equal 'bodleian_service_root="http://localhost:17175/bodleian"'
    end
  end
end