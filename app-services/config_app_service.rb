
require_relative "../domain/services/config_service.rb"
require_relative "../domain/services/encryption_service.rb"

class ConfigAppService
  def get_config(identifier)
    config_service = ConfigService.new
    config = config_service.get_config(identifier)

    if config.encrypted?
      encryption_service = EncryptionService.new
      config_content = encryption_service.decrypt(config.content)
      config
    end
  end

  def get_all_configs
    config_service = ConfigService.new
    config_service.get_all_configs
  end
end