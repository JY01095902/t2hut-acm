
require "logger"

class AliyunACMAPIObject
  attr_reader :access_key
  attr_reader :secret_key
  attr_reader :region_id
  def initialize
    env = ENV["T2HUT_ENV"]
    logger = Logger.new(STDERR)
    if env == nil || env.empty?
      logger.error("acm params init error: env can not be empty.")
      return
    end
    if env == "dev"
      @region_id = "cn-shanghai"
      @endpoint = "acm.aliyun.com"
      @namespace = "cd7a3417-103e-46a5-be49-0d4f83d4f947"
    elsif env == "stg"
      @region_id = "cn-beijing"
      @endpoint = "addr-bj-internal.edas.aliyun.com"
      @namespace = "78b82aaf-a533-4997-8dfa-1a89a4e863f2"
    else
      logger.error("acm params init error: can not run on #{env} environment.")
      return
    end

    @access_key = ENV["T2HUT_ACM_ACCESS_KEY"]
    @secret_key = ENV["T2HUT_ACM_SECRET_KEY"]
    @server_ip = get_server_ip(@endpoint)
  end

  def generate_url(group_id, config_id)
    query = [
      "tenant=#{URI.encode_www_form_component(@namespace)}",
      "group=#{URI.encode_www_form_component(group_id)}",
      "dataId=#{URI.encode_www_form_component(config_id)}"
    ]
    url = "http://#{@server_ip}:8080/diamond-server/config.co?#{query.join("&")}"
    
    return url
  end

  def generate_headers(group_id)
    timestamp = (Time.new.to_f * 1000).to_i

    return {
      "Spas-AccessKey": @access_key,
      "timeStamp": timestamp.to_s,
      "Spas-Signature": sign(@secret_key, @namespace, group_id, timestamp),
    }
  end

  private

  def sign(secret_key, namespace, group_id, timestamp)
    sign_string = "#{namespace}+#{group_id}+#{timestamp}"

    return Base64.strict_encode64(
             OpenSSL::HMAC.digest("sha1", secret_key, sign_string)
           )
  end

  def get_server_ip(endpoint)
    uri = URI("http://#{endpoint}:8080/diamond-server/diamond")
    client = HTTPClient.new
    response = client.get(uri)

    if response.status_code != 200 
      logger = Logger.new(STDERR)
      logger.error("acm params get server ip error, body is: #{response.body}.")
      return
    end
    
    return nil if response.body == nil || response.body.size <= 0

    regexp = /\r\n|[\r\n]/
    server_ip = response.body.split(regexp)[0]
    return server_ip
  end
end