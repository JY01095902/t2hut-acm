class Config
  def initialize(group, data_id)
    @group = group
    @data_id = data_id
    @content = get_content
  end

  def refresh
    @content = get_content
  end

  private
  def get_content 
    ""
  end
end

class ConfigResource
  def initialize(config)
    @id = "#{config.group}|#{config.data_id}"
    @config = config
    @decryptor = nil
    @content = get_content
  end
 
  def refresh
    @config.refresh
    @content = get_content
  end

  private
  def encrypted?
    @config.data_id.start_with?("cipher-")
  end

  def get_content
    content = @config.content
    if encrypted?
      content = @decryptor.decrypt(content)
    end
    content
  end
end

# class WatchedConfig
#   def initialize(config)
#     @config = config
#     @content = config.content
#   end

#   private
# end

def A
  "", ""
end

puts A()