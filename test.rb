
require "thread"

t1 = Thread.new {
  loop do
    puts 1
    sleep 1
  end
}


t2 = Thread.new {
  sleep 5
  t1.kill
  t1 = Thread.new {
    loop do
      puts 2
      sleep 1
    end
  }
}
sleep 50