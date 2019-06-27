
require "base64"
require_relative "../objects/acm_params.rb"
require_relative "../../infra/http_client.rb"

class ACMService
  def initialize
    @params = ACMParams.new
  end

  def get_config(group_code, config_id)
    url = generate_url(@params.server_ip, @params.namespace, group_code, config_id)
    headers = generate_headers(@params.access_key, @params.secret_key, @params.namespace, group_code)

    client = HTTPClient.new
    response = client.get(url, headers)

    return response.body if response.status_code == 200 
    return nil
  end

  def generate_url(server_ip, namespace, group_code, config_id)
    query = [
      "tenant=#{URI.encode_www_form_component(namespace)}",
      "group=#{URI.encode_www_form_component(group_code)}",
      "dataId=#{URI.encode_www_form_component(config_id)}"
    ]
    url = "http://#{server_ip}:8080/diamond-server/config.co?#{query.join("&")}"
    
    return url
  end

  def generate_headers(access_key, secret_key, namespace, group_code)
    timestamp = (Time.new.to_f * 1000).to_i

    return {
      "Spas-AccessKey": access_key,
      "timeStamp": timestamp.to_s,
      "Spas-Signature": sign(secret_key, namespace, group_code, timestamp),
    }
  end

  def sign(secret_key, namespace, group_code, timestamp)
    sign_string = "#{namespace}+#{group_code}+#{timestamp}"

    return Base64.strict_encode64(
             OpenSSL::HMAC.digest("sha1", secret_key, sign_string)
           )
  end
end