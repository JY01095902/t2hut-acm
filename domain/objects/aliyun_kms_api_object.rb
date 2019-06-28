require "base64"
require "time"
require "cgi"

class AliyunKMSAPIObject
  def initialize(access_key, secret_key, region_id, key_id = nil)
    @access_key = access_key
    @secret_key = secret_key
    @region_id = region_id
    @key_id = key_id
    @signature_method = "HMAC-SHA1"
    @signature_version = "1.0"
    @version = "2016-01-20"
    @format = "JSON"
  end

  def generate_url(ciphertext)
    params = {
      Format: @format,
      AccessKeyId: @access_key,
      Action: "Decrypt",
      SignatureMethod: @signature_method,
      SignatureVersion: @signature_version,
      Timestamp: Time.now.utc.iso8601,
      Version: @version,
      CiphertextBlob: ciphertext,
    }

    canonicalized_query_string = ""
    params.sort.each { |k, v|
      canonicalized_query_string += "&#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"
    }
    canonicalized_query_string = canonicalized_query_string[1..canonicalized_query_string.size - 1].gsub("+", "%20")

    string_to_sign = "GET" + "&" + CGI.escape("/") + "&" + CGI.escape(canonicalized_query_string)
    key = @secret_key + "&"
    signature = Base64.strict_encode64(
                  OpenSSL::HMAC.digest("sha1", key, string_to_sign)
                )

    url = "https://kms.#{@region_id}.aliyuncs.com/?" + canonicalized_query_string + "&Signature=" + CGI.escape(signature)
  end
end