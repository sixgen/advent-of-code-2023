
# Read the file input
dirname = File.basename(Dir.getwd)
input = File.read("input")
input = input.split("\n")
results = []
# get first and last numbers in string
input.each do |line|
    nums_in_line = line.scan(/\d/)
    # this isn't actually adding them its string concatenation
    results << nums_in_line[0] + nums_in_line[-1]
    puts nums_in_line[0] + nums_in_line[-1]
end
total = 0
results.each do |res|
    # here we convert to integer
    total += res.to_i
end

puts total