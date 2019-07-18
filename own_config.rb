require 'singleton'
# require "base64"
# require "json"
require "toml"
require_relative "domain/objects/topic.rb"
require_relative "domain/entities/config.rb"

class OwnConfig
  include Singleton

  attr_reader :topics
  attr_reader :api_service_enable

  def update_topics(config)
    load_topics(config)
  end

  def update_common(config)
    load_common(config)
  end

  private
  def initialize
    topics_config = Config.new(Config.generate_identifier("T2HUT", "t2hut.acm.topics"))
    load_topics(topics_config)

    common_config = Config.new(Config.generate_identifier("T2HUT", "t2hut.acm.common"))
    load_common(common_config)
  end

  def load_common(config)
    unless config.content.empty?
      content = config.content.gsub("\r", "")
      common_config = TOML.load(content) 
      @api_service_enable = common_config["api_service_enable"]
    end
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