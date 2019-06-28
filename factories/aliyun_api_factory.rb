
require_relative "../domain/objects/aliyun_acm_api_object.rb"
require_relative "../domain/objects/aliyun_kms_api_object.rb"

class AliyunAPIFactory
  def create_aliyun_api_object(type)
    if type == "acm"
      AliyunACMAPIObject.new
    elsif type == "kms"
      acm_obj = AliyunACMAPIObject.new
      AliyunKMSAPIObject.new(acm_obj.access_key, acm_obj.secret_key, acm_obj.region_id)
    end
  end
end