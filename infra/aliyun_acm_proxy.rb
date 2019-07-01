require_relative "http_client.rb"
require "base64"
require "time"

class AliyunACMProxy
  attr_reader :access_key
  attr_reader :secret_key
  attr_reader :region_id

  def initialize
    env = ENV["T2HUT_ENV"]
    if env == "dev"
      @region_id = "cn-shanghai"
      @endpoint = "acm.aliyun.com"
      @namespace = "cd7a3417-103e-46a5-be49-0d4f83d4f947"
      @access_key = ENV["T2HUT_ACM_ACCESS_KEY"]
      @secret_key = ENV["T2HUT_ACM_SECRET_KEY"]
      @server_ip = AliyunACMProxy.get_server_ip(@endpoint)
    elsif env == "stg"
      @region_id = "cn-beijing"
      @endpoint = "addr-bj-internal.edas.aliyun.com"
      @namespace = "78b82aaf-a533-4997-8dfa-1a89a4e863f2"
      @access_key = ENV["T2HUT_ACM_ACCESS_KEY"]
      @secret_key = ENV["T2HUT_ACM_SECRET_KEY"]
      @server_ip = AliyunACMProxy.get_server_ip(@endpoint)
    end if valid_env?(env)
  end

  def valid?
    @is_valid
  end

  def get_config(group_id, config_id)
    url = generate_url(group_id, config_id)
    headers = generate_headers(group_id)
    response = HTTPClient.get(url, headers)
    config = response.status_code == 200 ? response.body : nil
  end

  private
  def valid_env?(env)
    @is_valid = env != nil && ["dev", "stg"].include?(env)
  end

  def self.get_server_ip(endpoint)
    url = "http://#{endpoint}:8080/diamond-server/diamond"
    response = HTTPClient.get(url)
    
    server_ip = nil
    if response.status_code == 200 && response.body != nil && response.body.size > 0
      regexp = /\r\n|[\r\n]/
      server_ip = response.body.split(regexp)[0]
    end
  end

  def generate_url(group_id, config_id)
    query = [
      "tenant=#{URI.encode_www_form_component(@namespace)}",
      "group=#{URI.encode_www_form_component(group_id)}",
      "dataId=#{URI.encode_www_form_component(config_id)}"
    ]
    url = "http://#{@server_ip}:8080/diamond-server/config.co?#{query.join("&")}"
  end
  
  def generate_headers(group_id)
    timestamp = (Time.new.to_f * 1000).to_i
    sign_string = "#{@namespace}+#{group_id}+#{timestamp}"
    signature = Base64.strict_encode64(
                  OpenSSL::HMAC.digest("sha1", @secret_key, sign_string)
                )
    return {
      "Spas-AccessKey": @access_key,
      "timeStamp": timestamp.to_s,
      "Spas-Signature": signature,
    }
  end
end



