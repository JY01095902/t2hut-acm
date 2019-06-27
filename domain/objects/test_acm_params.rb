require "minitest/autorun"
require_relative "acm_params.rb"

describe ACMParams do
  describe "初始化" do
    it "env是空" do
      ENV["T2HUT_ENV"] = nil
      params = ACMParams.new
      params.region_id.must_be_nil
      params.endpoint.must_be_nil
      params.namespace.must_be_nil
      params.access_key.must_be_nil
      params.secret_key.must_be_nil
      params.server_ip.must_be_nil
    end
    it "env是dev" do
      ENV["T2HUT_ENV"] = "dev"
      ENV["T2HUT_ACM_ACCESS_KEY"] = "hello-dev"
      ENV["T2HUT_ACM_SECRET_KEY"] = "world-dev"
      Time.stub :now, Time.at(0) do 
        class ACMParams
          def get_server_ip(region_id)
            return
          end
        end
        params = ACMParams.new
        params.region_id.must_equal "cn-shanghai"
        params.endpoint.must_equal "acm.aliyun.com"
        params.namespace.must_equal "cd7a3417-103e-46a5-be49-0d4f83d4f947"
        params.access_key.must_equal "hello-dev"
        params.secret_key.must_equal "world-dev"

        load "domain/objects/acm_params.rb"
      end
    end
    it "env是stg" do
      ENV["T2HUT_ENV"] = "stg"
      ENV["T2HUT_ACM_ACCESS_KEY"] = "hello-stg"
      ENV["T2HUT_ACM_SECRET_KEY"] = "world-stg"
      Time.stub :now, Time.at(0) do 
        class ACMParams
          def get_server_ip(region_id)
            return
          end
        end
        params = ACMParams.new
        params.region_id.must_equal "cn-beijing"
        params.endpoint.must_equal "addr-bj-internal.edas.aliyun.com"
        params.namespace.must_equal "78b82aaf-a533-4997-8dfa-1a89a4e863f2"
        params.access_key.must_equal "hello-stg"
        params.secret_key.must_equal "world-stg"

        load "domain/objects/acm_params.rb"
      end
    end
    it "env是其他（非dev或stg）" do
      ENV["T2HUT_ENV"] = "other"
      params = ACMParams.new
      params.region_id.must_be_nil
      params.endpoint.must_be_nil
      params.namespace.must_be_nil
      params.access_key.must_be_nil
      params.secret_key.must_be_nil
      params.server_ip.must_be_nil
    end
  end

  describe "获取服务器ip" do
    it "远程调用成功（200）" do
      Time.stub :now, Time.at(0) do 
        class HTTPClient
          def get(uri, headers = nil)
            body = "127.0.0.1
                    127.0.0.2
                    127.0.0.3
                  "
            return HTTPResponse.new(200, body, nil)
          end
        end
        ENV["T2HUT_ENV"] = "dev"
        params = ACMParams.new
        params.server_ip.must_equal "127.0.0.1"
        load "domain/objects/acm_params.rb"
      end
    end
    it "远程调用失败（非200）" do
      Time.stub :now, Time.at(0) do 
        class HTTPClient
          def get(uri, headers = nil)
            body = nil
            return HTTPResponse.new(500, body, nil)
          end
        end
        ENV["T2HUT_ENV"] = "dev"
        params = ACMParams.new
        params.server_ip.must_be_nil
        load "domain/objects/acm_params.rb"
      end
    end
  end
end