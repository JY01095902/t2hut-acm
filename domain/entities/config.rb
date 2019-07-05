
require "base64"
require_relative "../../repositories/config_repository.rb"

class Config
  attr_reader :identifier
  attr_reader :group
  attr_reader :data_id
  attr_reader :content

  def initialize(group, data_id)
    @identifier = generate_identifier(group, data_id)
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

  def generate_identifier(group, data_id)
    Base64.strict_encode64("#{group}|#{data_id}")
  end

  def self.config_repository_class
    @config_repository_class || ConfigRepository
  end
end