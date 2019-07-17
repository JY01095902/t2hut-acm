require "minitest/autorun"
require_relative "config_surface.rb"

class FakeAliyunKMSProxy
  def decrypt(ciphertext)
    '{ "Plaintext" : "This is plaintext." }'
  end
end

class FakeAliyunProxyFactory
  def create_aliyun_proxy(type)
    if type == "acm"
       nil
    elsif type == "kms"
      FakeAliyunKMSProxy.new
    end
  end
end

describe ConfigSurface do
  describe "init" do
    it "data_id非‘cipher-’开头，content应该为原始值" do
      config = ConfigSurface.new("VDJIVVR8dDJodXQtYWNtLXRvcGljcw==", "T2HUT", "t2hut-acm-topics", "fake config's content.")
      config.identifier.must_equal "VDJIVVR8dDJodXQtYWNtLXRvcGljcw=="
      config.group.must_equal "T2HUT"
      config.data_id.must_equal "t2hut-acm-topics"
      config.content.must_equal "fake config's content."
    end
    it "data_id以‘cipher-’开头，content应该为根据原始content解密后的内容" do
      ConfigSurface.instance_eval { @aliyun_proxy_factory_class = FakeAliyunProxyFactory }
      config = ConfigSurface.new("VDJIVVR8Y2lwaGVyLXQyaHV0LWFjbS10b3BpY3M=", "T2HUT", "cipher-t2hut-acm-topics", "fake config's content.")
      config.identifier.must_equal "VDJIVVR8Y2lwaGVyLXQyaHV0LWFjbS10b3BpY3M="
      config.group.must_equal "T2HUT"
      config.data_id.must_equal "cipher-t2hut-acm-topics"
      config.content.must_equal "This is plaintext."
    end
  end
end