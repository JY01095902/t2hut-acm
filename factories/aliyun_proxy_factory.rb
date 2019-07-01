
require_relative "../infra/aliyun_acm_proxy.rb"
require_relative "../infra/aliyun_kms_proxy.rb"

class AliyunProxyFactory
  def create_aliyun_proxy(type)
    if type == "acm"
      AliyunACMProxy.new
    elsif type == "kms"
      acm_proxy = AliyunACMProxy.new
      AliyunKMSProxy.new(acm_proxy.access_key, acm_proxy.secret_key, acm_proxy.region_id)
    end
  end
end