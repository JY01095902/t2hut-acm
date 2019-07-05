require "minitest/autorun"
require_relative "api_result.rb"

class Person
  def initialize(name, age)
    @name = name
    @age = age
  end

  def to_hash
    {
      name: @name,
      age: @age
    }
  end
end

describe APIResult do
  describe "对象模板" do
    it "对象没有to_hash方法，应该返回
      {
        data: nil
      }" do
      template = APIResult.get_object_template(nil)
      template.class.name.must_equal "Hash"
      template["data"].must_be_nil
    end
    it "对象有to_hash方法，应该返回
      {
        data: {
          name: 'tom',
          age: 3
        }
      }" do
      tom = Person.new("tom", 3)
      template = APIResult.get_object_template(tom)
      template.class.name.must_equal "Hash"

      template[:data].class.name.must_equal "Hash"
      template[:data][:name].must_equal "tom"
      template[:data][:age].must_equal 3
    end
  end
  describe "数组模板" do
    it "数组中的对象没有to_hash方法，应该返回
      {
        data: {
          total_items: 0,
          items: []
        }
      }" do
      people = [nil, nil, nil]
      template = APIResult.get_array_template(people, people.size)
      template.class.name.must_equal "Hash"
      template[:data].class.name.must_equal "Hash"
      template[:data][:total_items].must_equal people.size
      template[:data][:items].class.name.must_equal "Array"
      template[:data][:items].size.must_equal 0
    end
    it "数组中的对象有to_hash方法，应该返回
      {
        data: {
          total_items: 0,
          items: [{
            name: 'tom',
            age: 3
          },{
            name: 'kite',
            age: 4
          }]
        }
      }" do
      tom = Person.new("tom", 3)
      kite = Person.new("kite", 4)
      people = [tom, kite]
      template = APIResult.get_array_template(people, people.size)
      template.class.name.must_equal "Hash"
      template[:data].class.name.must_equal "Hash"
      template[:data][:total_items].must_equal people.size
      template[:data][:items].class.name.must_equal "Array"
      template[:data][:items].size.must_equal 2
      template[:data][:items][0][:name].must_equal "tom"
      template[:data][:items][0][:age].must_equal 3
      template[:data][:items][1][:name].must_equal "kite"
      template[:data][:items][1][:age].must_equal 4
    end
  end
end