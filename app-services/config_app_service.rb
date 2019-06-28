
require_relative "../domain/services/config_service.rb"
require_relative "../domain/services/encryption_service.rb"

class ConfigAppService
  def get_config(group_id, config_id)
    config_service = ConfigService.new
    config = config_service.get_config(group_id, config_id)

    if config_id.start_with?("cipher-")
      encryption_service = EncryptionService.new
      config = encryption_service.decrypt(config)
    end
  end
end