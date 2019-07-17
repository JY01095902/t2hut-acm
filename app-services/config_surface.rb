
require_relative "../domain/entities/config.rb"
require_relative "../factories/aliyun_proxy_factory.rb"

class ConfigSurface
  attr_reader :identifier
  attr_reader :group
  attr_reader :data_id
  attr_reader :content

  def initialize(identifier, group, data_id, content)
    @identifier = identifier
    @group = group
    @data_id = data_id

    if @data_id.start_with?("cipher-")
      @content = decrypt(content)
    else
      @content = content
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

  private
  def self.aliyun_proxy_factory_class
    @aliyun_proxy_factory_class || AliyunProxyFactory
  end
  
  def decrypt(ciphertext)
    @kms_proxy = ConfigSurface.aliyun_proxy_factory_class.new.create_aliyun_proxy("kms")
    result = @kms_proxy.decrypt(ciphertext)
    if result != nil 
      json_result = JSON.parse(result)
      json_result["Plaintext"]
    end
  end
end