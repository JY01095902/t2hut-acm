require 'singleton'

class A
  include Singleton

  private
  def initialize(txt)
    puts txt
  end
  # def initialize
  #   puts "txt"
  # end
end

A.instance("C")
# A.instance("cv")