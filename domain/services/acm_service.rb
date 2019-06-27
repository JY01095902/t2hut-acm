require_relative "../objects/ACMParams.rb"

class ACMService
  def initialize
    @params = ACMParams.new
  end

  def get_config(group_code, config_id)
    return ""
  end
end