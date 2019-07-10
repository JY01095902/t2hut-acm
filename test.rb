

def run 
  puts 1
  puts block_given?
  yield if block_given?
  puts 2
end

run