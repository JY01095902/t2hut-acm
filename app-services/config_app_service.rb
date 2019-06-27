
require_relative "../domain/services/acm_service.rb"
require_relative "../domain/services/kms_service.rb"

class ConfigAppService
    def get_config(group_code, config_id)
      acm = ACMService.new
      config = acm.get_config(group_code, config_id)

      kms = KMSService.new
      config = kms.decrypt(config)

      return config
    end
end