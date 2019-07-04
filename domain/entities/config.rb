
require_relative "../../repositories/config_repository.rb"

class Config
  attr_reader :group_id
  attr_reader :data_id
  attr_reader :content

  def initialize(group_id, data_id)
    @group_id = group_id
    @data_id = data_id

    @repository = ConfigRepository.new
    @content = load_content(@repository, group_id, data_id)
  end

  def encrypted?
    @data_id.start_with?("cipher-")
  end

  def refresh
    @content = load_content(@repository, group_id, data_id)
  end

  private
  def load_content(repository, group_id, data_id)
    repository.get_config(group_id, data_id)
  end
end