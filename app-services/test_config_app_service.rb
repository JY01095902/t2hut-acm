require "minitest/autorun"
require "base64"
require_relative "config_app_service.rb"
require_relative "../domain/entities/config.rb"

class FakeConfig
  attr_accessor :content
  def initialize(identifier)
    puts identifier
    group, data_id = parse_identifier(identifier)
    @identifier = identifier
    @group = group
    @data_id = data_id
    @content = "AAA"
  end 

  def encrypted?
    @data_id.start_with?("cipher-")
  end

  def parse_identifier(identifier)
    config_id = Base64.strict_decode64(identifier)
    idx = config_id.index("|")
    group = config_id[0...idx]
    data_id = config_id[idx + 1..config_id.size]

    return group, data_id
  end
end

class FakeConfigService
  def get_config(identifier)
    config = FakeConfig.new(identifier)
  end
end

class FakeEncryptionService
  def decrypt(text)
    "BBB"
  end
end

describe ConfigAppService do
  describe "查询配置信息" do
    it "查询非加密的配置信息，应该返回AAA" do
      ConfigAppService.instance_eval { 
        @config_service_class = FakeConfigService 
        @encryption_service_class = FakeEncryptionService
      }
      service = ConfigAppService.new
      config = service.get_config(Config.generate_identifier("T2HUT", "t2hut-acm-customers"))
      config.wont_be_nil
      config.content.must_equal "AAA"
    end
    it "查询加密的配置信息，应该返回BBB" do
      ConfigAppService.instance_eval { 
        @config_service_class = FakeConfigService 
        @encryption_service_class = FakeEncryptionService
      }
      service = ConfigAppService.new
      config = service.get_config(Config.generate_identifier("BODLEIAN", "cipher-t2hut.service.point"))
      config.wont_be_nil
      config.encrypted?.must_equal true
      config.content.must_equal "BBB"
    end
  end
end