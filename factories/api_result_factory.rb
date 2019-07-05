
require_relative "../infra/api_result.rb"

class APIResultFactory
  def self.create_api_result(type)
    if type == "single"
      APISingleResult
    elsif type == "array"
      APIArrayResult      
    end
  end
end