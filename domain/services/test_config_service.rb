require "minitest/autorun"
require_relative "config_service.rb"

describe ConfigService do
  describe "获取配置" do
    it "获取存在的配置" do
      service = ConfigService.new
      config = service.get_config("T2HUT", "cipher-t2hut.service.point")
      config.wont_be_nil
    end
    it "获取不存在的配置" do
      service = ConfigService.new
      config = service.get_config("T2HUT", "XXX")
      config.must_be_nil
    end
  end
end