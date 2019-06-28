
require "json"
require_relative "../../factories/aliyun_api_factory.rb"

class EncryptionService
  def decrypt(ciphertext)
    kms_obj =AliyunAPIFactory.new.create_aliyun_api_object("kms")
    url = kms_obj.generate_url(ciphertext)

    response = Net::HTTP.get_response(URI(url))
    result = JSON.parse(response.body)
    result["Plaintext"]
  end
end
