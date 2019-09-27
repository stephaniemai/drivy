require_relative 'main'

# ==== MY TESTS ====
puts '/// TESTS ///'

puts 'COMPARE PARSED JSON'
expected_output = JSON.parse(File.read('data/expected_output.json'))
my_output = JSON.parse(File.read('data/output.json'))
p my_output == expected_output

puts 'COMPARE STRINGS'
expected_output = File.read('data/expected_output.json')
my_output = File.read('data/output.json')
p my_output == expected_output
