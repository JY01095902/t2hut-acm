
class APIResult
  def initialize(data, total_items)
    if data.class == "Array"
    else
    end
  end

  def self.get_array_template(data, total_items)
    items = []
    if data.size > 0
      data.each {|item|
        items << item.to_hash if item.respond_to?(:to_hash) 
      }
    end

    template = {
      data: {
        total_items: total_items,
        items: items
      }
    }
  end

  def self.get_object_template(data)
    template = {
      data: data.respond_to?(:to_hash) ? data.to_hash : nil
    }
  end
end