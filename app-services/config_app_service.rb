
require_relative "../domain/services/config_service.rb"
require_relative "config_surface.rb"

class ConfigAppService
  def initialize
    @config_service = ConfigAppService.config_service_class.new
  end

  def get_config(identifier)
    config = @config_service.get_config(identifier)
    config_surface = ConfigSurface.new(config.identifier, config.group, config.data_id, config.content)
  end

  def get_all_configs
    config_surfaces = []
    @config_service.get_all_configs.each{|config|
      config_surfaces << ConfigSurface.new(config.identifier, config.group, config.data_id, config.content)
    }
    config_surfaces
  end

  private
  def self.config_service_class
    @config_service_class || ConfigService
  end
end