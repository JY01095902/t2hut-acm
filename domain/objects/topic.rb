
class Consumer
  attr_reader :endpoint
  def initialize(endpoint)
    @endpoint = endpoint
  end
end

class Topic
  attr_reader :group
  attr_reader :data_id
  attr_reader :consumers

  def initialize(group, data_id)
    @group = group
    @data_id = data_id
    @consumers = []
  end
  
  def add_consumer(consumer)
    @consumers << consumer
  end
end