require 'singleton'
require "base64"
require "json"
require "toml"
require_relative "domain/entities/config.rb"
require_relative "domain/objects/topic.rb"
require_relative "app-services/config_app_service.rb"

module OWNConfig
  class TopicConfig
    include Singleton

    attr_reader :topics

    def refresh
      load_config
    end

    private

    def initialize
      load_config
    end

    def load_config
      config_id = Config.generate_identifier("T2HUT", "t2hut.acm.topics")
      config_app_service = OWNConfig::TopicConfig.config_app_service_class.new
      config = config_app_service.get_config(config_id)
      
      unless config.content == nil 
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

    def self.config_app_service_class
      @config_app_service_class || ConfigAppService
    end
  end
end