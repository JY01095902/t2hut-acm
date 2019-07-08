
require "base64"
require "json"
require_relative "../../repositories/config_repository.rb"
require_relative "../../infra/http_client.rb"

class Config
  attr_reader :identifier
  attr_reader :group
  attr_reader :data_id
  attr_accessor :content

  def initialize(identifier)
    group, data_id = parse_identifier(identifier)
    @identifier = identifier
    @group = group
    @data_id = data_id

    @repository = Config.config_repository_class.new
    @content = @repository.get_config(group, data_id)
  end

  def encrypted?
    @data_id.start_with?("cipher-")
  end

  def refresh
    @content = @repository.get_config(group, data_id)

    if @data_id == "cipher-t2hut.bodleian.catalog.oss"
      url = "http://10.202.101.62:9292/catalog/events"
      data = {
        event_name: "ConfigChanged",
        payload: {
          config_id: @identifier,
          group: @group,
          data_id: @data_id
        }
      }
      puts "JSON(data) ----- #{JSON(data)}"

      response = HTTPClient.post(url, JSON(data), { "Content-Type" => "application/json" })

      puts "response.body ------- #{response.status_code}" 
    end
  end

  def to_hash
    result = {
      identifier: @identifier,
      group: @group,
      data_id: @data_id,
      content: @content,
    }
  end


  def self.generate_identifier(group, data_id)
    Base64.strict_encode64("#{group}|#{data_id}")
  end

  private

  def parse_identifier(identifier)
    config_id = Base64.strict_decode64(identifier)
    idx = config_id.index("|")
    group = config_id[0...idx]
    data_id = config_id[idx + 1..config_id.size]

    return group, data_id
  end

  def self.config_repository_class
    @config_repository_class || ConfigRepository
  end
end