
class APIArrayResult
  def self.create(data, total_items)
    items = []
    if data.size > 0
      data.each {|item|
        items << item.to_hash if item.respond_to?(:to_hash) 
      }
    end

    {
      data: {
        total_items: total_items,
        items: items
      }
    }
  end
end

class APISingleResult
  def self.create(data)
    { data: data.respond_to?(:to_hash) ? data.to_hash : nil }
  end
end