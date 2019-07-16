
require "base64"
require "json"
require_relative "../../factories/aliyun_proxy_factory.rb"
require_relative "../../repositories/config_repository.rb"

class Config
  attr_reader :identifier
  attr_reader :group
  attr_reader :data_id
  attr_reader :content

  def initialize(group, data_id)
    @identifier = Base64.strict_encode64("#{group}|#{data_id}")
    @group = group
    @data_id = data_id

    @repository = Config.config_repository_class.instance
    @kms_proxy = Config.aliyun_proxy_factory_class.new.create_aliyun_proxy("kms")

    @content = get_content
  end

  def refresh
    @content = get_content
  end

  def self.parse_identifier(identifier)
    config_id = Base64.strict_decode64(identifier)
    idx = config_id.index("|")
    group = config_id[0...idx]
    data_id = config_id[idx + 1..config_id.size]
    return group, data_id
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
  def self.config_repository_class
    @config_repository_class || ConfigRepository
  end

  def self.aliyun_proxy_factory_class
    @aliyun_proxy_factory_class || AliyunProxyFactory
  end

  def encrypted?
    @data_id.start_with?("cipher-")
  end

  def decrypt(ciphertext)
    result = @kms_proxy.decrypt(ciphertext)
    if result != nil 
      json_result = JSON.parse(result)
      json_result["Plaintext"]
    end
  end

  def get_content
    content = @repository.get_content(group, data_id)
    @original_content = content
    if encrypted?
      content = decrypt(content)
    end
    content
  end
end

class WatchedConfig < Config
  attr_reader :md5

  def initialize(group, data_id)
    super(group, data_id)
    @md5 = OpenSSL::Digest::MD5.hexdigest(@original_content)
  end
end