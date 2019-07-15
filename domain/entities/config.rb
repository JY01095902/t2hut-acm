
require "base64"
require_relative "../../repositories/config_repository.rb"

class Config
  attr_reader :identifier
  attr_reader :group
  attr_reader :data_id
  attr_accessor :content

  def initialize(group, data_id)
    @identifier = Base64.strict_encode64("#{group}|#{data_id}")
    init(group, data_id)
  end

  def self.get(identifier)
    config_id = Base64.strict_decode64(identifier)
    idx = config_id.index("|")
    group = config_id[0...idx]
    data_id = config_id[idx + 1..config_id.size]
    Config.new(group, data_id)
  end

  def encrypted?
    @data_id.start_with?("cipher-")
  end

  def refresh
    @content = @repository.get_config(group, data_id)
  end

  def to_hash
    result = {
      identifier: @identifier,
      group: @group,
      data_id: @data_id,
      content: @content,
    }
  end

  private
  def init(group, data_id)
    @group = group
    @data_id = data_id
    @repository = Config.config_repository_class.new
    @content = @repository.get_config(group, data_id)
  end

  def self.config_repository_class
    @config_repository_class || ConfigRepository
  end
end