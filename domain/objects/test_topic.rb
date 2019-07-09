require "minitest/autorun"
require_relative "topic.rb"

describe Topic do
  describe "添加consumer" do
    it "成功初始话后，group应该为T2HUT，data_id应该为t2hut-acm-topics" do
      topic = Topic.new("T2HUT", "t2hut-acm-topics")
      topic.group.must_equal "T2HUT"
      topic.data_id.must_equal "t2hut-acm-topics"
    end
  end
  describe "添加consumer" do
    it "添加consumer后，topic.consumers的数量应该加一" do
      topic = Topic.new("T2HUT", "t2hut-acm-topics")
      topic.consumers.size.must_equal 0
      topic.add_consumer(Consumer.new("http://127.0.0.1:9292/events"))
      topic.consumers.size.must_equal 1
      topic.consumers[0].endpoint.must_equal "http://127.0.0.1:9292/events"
      topic.add_consumer(Consumer.new("http://www.baidu.com"))
      topic.consumers.size.must_equal 2
      topic.consumers[1].endpoint.must_equal "http://www.baidu.com"
    end
  end
end