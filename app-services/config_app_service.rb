
require_relative "../domain/services/config_service.rb"
require_relative "../domain/services/encryption_service.rb"

class ConfigAppService
  def get_config(group_id, config_id)
    config_service = ConfigService.new
    config = config_service.get_config(group_id, config_id)

    if config.encrypted?
      encryption_service = EncryptionService.new
      config_content = encryption_service.decrypt(config.content)
    else
      puts OpenSSL::Digest::MD5.hexdigest(config.content)
      config.content
    end
  end
end