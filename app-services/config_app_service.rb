
require_relative "../domain/services/config_service.rb"
require_relative "../domain/services/encryption_service.rb"

class ConfigAppService
  def get_config(identifier)
    config_service = ConfigAppService.config_service_class.new
    config = config_service.get_config(identifier)
    
    if config.encrypted?
      encryption_service = ConfigAppService.encryption_service_class.new
      config.content = encryption_service.decrypt(config.content)
      config
    end

    config
  end

  def get_config_by_group_and_data_id(group, data_id)
    config_service = ConfigAppService.config_service_class.new
    config = config_service.get_config_by_group_and_data_id(group, data_id)
    
    if config.encrypted?
      encryption_service = ConfigAppService.encryption_service_class.new
      config.content = encryption_service.decrypt(config.content)
      config
    end

    config
  end

  def get_all_configs
    config_service = ConfigAppService.config_service_class.new
    config_service.get_all_configs
  end

  def self.config_service_class
    @config_service_class || ConfigService
  end

  def self.encryption_service_class
    @encryption_service_class || EncryptionService
  end
end