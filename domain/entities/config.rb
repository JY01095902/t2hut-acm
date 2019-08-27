
require_relative "../../repositories/config_repository.rb"

class Config
  attr_reader :identifier
  attr_reader :group
  attr_reader :data_id
  attr_reader :content

  def initialize(identifier)
    group, data_id = Config.parse_identifier(identifier)
    if group.empty? || data_id.empty?
      Log.info("identifier的格式不正确")
      return
    end
    @identifier = identifier
    @group = group
    @data_id = data_id
    @repository = Config.config_repository_class.instance
    load_content
  end

  def refresh
    load_content
  end

  private
  def load_content
    @content = @repository.get_content(group, data_id)
  end

  def self.parse_identifier(identifier)
    begin
      config_id = Base64.strict_decode64(identifier)
    rescue => exception
      return "", ""
    end
    idx = config_id.index("|")
    if idx == nil
      return "", ""
    end
    group = config_id[0...idx]
    data_id = config_id[idx + 1..config_id.size]
    return group, data_id
  end

  def self.generate_identifier(group, data_id)
    Base64.strict_encode64("#{group}|#{data_id}") 
  end

  def self.config_repository_class
    @config_repository_class || ConfigRepository
  end
end