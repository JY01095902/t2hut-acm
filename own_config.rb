require 'singleton'
# require "base64"
# require "json"
require "toml"
require_relative "domain/objects/topic.rb"
require_relative "domain/entities/config.rb"

class OwnConfig
  include Singleton

  attr_reader :topics

  def update_topics(config)
    load_topics(config)
  end

  private
  def initialize
    config = Config.new(Config.generate_identifier("T2HUT", "t2hut.acm.topics"))
    load_topics(config)
  end

  def load_topics(config)
    unless config.content.empty? 
      content = config.content.gsub("\r", "")
      topics_config = TOML.load(content) 
      topics = []
      topic_array = topics_config["topics"]
      topic_array.each{|topic_node|
        consumers_node = topic_node["consumers"]
        topic = Topic.new(topic_node["group"], topic_node["data_id"])
        consumers_node.each{|consumer_node|
          topic.add_consumer(Consumer.new(consumer_node["endpoint"]))
        }
        topics << topic
      }
      @topics = topics
    end
  end
end