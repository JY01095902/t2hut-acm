require "minitest/autorun"
require_relative "config.rb"

class FakeConfigAppService
  class FakeConfig
    attr_reader :content
    def initialize(content)
      @content = content
    end
  end
  def get_config(id)
    toml = '
      [[topics]]
      group = "T2HUT"
      data_id ="t2hut-acm-topics"
      [[topics.consumers]]
      endpoint = "http://10.202.101.62:9293/events"
      [[topics.consumers]]
      endpoint = "http://10.202.101.62:19293/events"

      [[topics]]
      group = "BODLEIAN"
      data_id ="cipher-t2hut.bodleian.catalog.oss"
      [[topics.consumers]]
      endpoint = "http://10.202.101.62:9292/events"
    ' 
    FakeConfig.new(toml)
  end
  def get_config_by_group_and_data_id(group, data_id)
    toml = '
      [[topics]]
      group = "T2HUT"
      data_id ="t2hut-acm-topics"
      [[topics.consumers]]
      endpoint = "http://10.202.101.62:9293/events"
      [[topics.consumers]]
      endpoint = "http://10.202.101.62:19293/events"

      [[topics]]
      group = "BODLEIAN"
      data_id ="cipher-t2hut.bodleian.catalog.oss"
      [[topics.consumers]]
      endpoint = "http://10.202.101.62:9292/events"
    ' 
    FakeConfig.new(toml)
  end
end

describe OWNConfig::OwnConfig do
  describe "初始化" do
    it "初始化成功后，应该有两个topic，内容应该跟toml文件中的一致" do
      OwnConfig.instance_eval{ @config_app_service_class = FakeConfigAppService }
      config = OwnConfig.instance
      config.topics.size.must_equal 2
      config.topics[0].consumers[0].endpoint.must_equal "http://10.202.101.62:9293/events"
      config.topics[0].group.must_equal "T2HUT"
      config.topics[0].data_id.must_equal "t2hut-acm-topics"
      config.topics[0].consumers[1].endpoint.must_equal "http://10.202.101.62:19293/events"
      config.topics[0].group.must_equal "T2HUT"
      config.topics[0].data_id.must_equal "t2hut-acm-topics"
      config.topics[1].consumers[0].endpoint.must_equal "http://10.202.101.62:9292/events"
      config.topics[1].group.must_equal "BODLEIAN"
      config.topics[1].data_id.must_equal "cipher-t2hut.bodleian.catalog.oss"
    end
  end
end