
require "base64"
require "time"
require_relative "http_client.rb"
# require "pp"

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

  def observe_change(group_id, config_id, content)
    puts generate_listen_url(group_id, config_id, content)
    puts generate_listen_headers(group_id)
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

  def generate_listen_url(group_id, config_id, content)
    data_id = URI.encode_www_form_component(config_id)
    group = URI.encode_www_form_component(group_id)
    tenant = URI.encode_www_form_component(@namespace)
    # contentMD5 = URI.encode_www_form_component(OpenSSL::Digest::MD5.hexdigest(content))
    contentMD5 = "f7ce9ae5b8ed029b3f901ad074f1278f"

    two = "\u0002"
    one = "\u0001"

    # two = '\x02'
    # one = '\x01'

    query = "#{data_id}#{two}#{group}#{two}#{contentMD5}#{two}#{tenant}#{one}"
    query = "Probe-Modify-Request=#{URI.encode_www_form_component(query)}"
    url = "http://#{@server_ip}:8080/diamond-server/config.co?#{query}"
  end

  def generate_listen_headers(group_id)
    headers = generate_headers(group_id)
    headers["longPullingTimeout"] = "30000"
    return headers
  end
end

# content = 'customers = [\r\n    \"hello-world-app\",\r\n    \"black-magic-app\",\r\n    \"black-magic-app4\"\r\n]\r\n\r\nlogLevel = WARN34455'

# content = '"customers = [
#   "hello-world-app",
#   "black-magic-app",
#   "black-magic-app4"
# ]

# logLevel = WARN34455"'
# puts AliyunACMProxy.new.observe_change("T2HUT", "t2hut-acm-customers", content)

# t2hut-acm-customers%02T2HUT%02cd7a3417-103e-46a5-be49-0d4f83d4f947%01

# pp URI.decode_www_form_component("t2hut-acm-customers%02T2HUT%02cd7a3417-103e-46a5-be49-0d4f83d4f947%01")