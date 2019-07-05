require "minitest/autorun"
require_relative "config.rb"

class FakeConfigRepository
  def initialize ; end
  def get_config(group, data_id)
    "fake config's content."
  end
end

describe Config do
  describe "初始化" do
    it "group和data_id都不为空，应该正确初始化" do
      Config.instance_eval { @config_repository_class = FakeConfigRepository }
      group = "T2HUT"
      data_id = "t2hut-acm-customers"
      config = Config.new(group, data_id)
      config.identifier.must_equal "VDJIVVR8dDJodXQtYWNtLWN1c3RvbWVycw=="
      config.content.must_equal "fake config's content."
    end
  end
  describe "验证是否是加密的配置" do
    it "‘cipher-’开头的data_id，应该返回true" do
      Config.instance_eval { @config_repository_class = FakeConfigRepository }
      group = "T2HUT"
      data_id = "cipher-t2hut-acm-customers"
      config = Config.new(group, data_id)
      config.encrypted?.must_equal true
    end
    it "非‘cipher-’开头的data_id，应该返回false" do
      Config.instance_eval { @config_repository_class = FakeConfigRepository }
      group = "T2HUT"
      data_id = "t2hut-acm-customers"
      config = Config.new(group, data_id)
      config.encrypted?.must_equal false
    end
  end
end