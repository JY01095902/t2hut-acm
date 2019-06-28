
require "json"
require_relative "../objects/acm_params.rb"
require_relative "../objects/kms_params.rb"

class EncryptionService
  def decrypt(ciphertext)
    acm_params = ACMParams.new
    kms_params = KMSParams.new(acm_params.access_key, acm_params.secret_key, acm_params.region_id)
    url = kms_params.generate_url(ciphertext)

    response = Net::HTTP.get_response(URI(url))
    result = JSON.parse(response.body)
    result["Plaintext"]
  end
end
