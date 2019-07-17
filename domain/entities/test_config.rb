require "minitest/autorun"
require 'singleton'
require_relative "config.rb"

class FakeConfigRepository
  include Singleton
  def get_content(group, data_id )
    if group == "T2HUT" && data_id = "t2hut-acm-topics"
      "fake config's content."
    else
      nil
    end
  end
end

describe Config do
  describe "init" do
    it "使用格式正确并且有内容的identifier，应该可以获得正确的Config" do
      Config.instance_eval { @config_repository_class = FakeConfigRepository }
      config = Config.new("VDJIVVR8dDJodXQtYWNtLXRvcGljcw==")
      config.identifier.must_equal "VDJIVVR8dDJodXQtYWNtLXRvcGljcw=="
      config.group.must_equal "T2HUT"
      config.data_id.must_equal "t2hut-acm-topics"
      config.content.must_equal "fake config's content."
    end
    it "使用格式正确但是没有内容的identifier，应该可以获得内容为空的Config" do
      config = Config.new("VEVTVF9HUk9VUHxURVNUX0RBVEFfSUQ=")
      config.identifier.must_equal "VEVTVF9HUk9VUHxURVNUX0RBVEFfSUQ="
      config.group.must_equal "TEST_GROUP"
      config.data_id.must_equal "TEST_DATA_ID"
      config.content.must_be_nil
    end
    it "使用格式不正确的identifier，应该可以获得Config对象，但是identifier, group, data_id和content都为nil" do
      config = Config.new("AAA")
      config.identifier.must_be_nil
      config.group.must_be_nil
      config.data_id.must_be_nil
      config.content.must_be_nil
      config = Config.new("QUFiYmNj")
      config.identifier.must_be_nil
      config.group.must_be_nil
      config.data_id.must_be_nil
      config.content.must_be_nil
    end
  end
end