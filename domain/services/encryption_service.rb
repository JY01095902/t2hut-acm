
require "json"
require_relative "../../factories/aliyun_proxy_factory.rb"

class EncryptionService
  def decrypt(ciphertext)
    kms_proxy = AliyunProxyFactory.new.create_aliyun_proxy("kms")
    result = kms_proxy.decrypt(ciphertext)
    if result != nil 
      json_result = JSON.parse(result)
      json_result["Plaintext"]
    end
  end
end
