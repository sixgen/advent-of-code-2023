# Read the file input
input = File.read("input")
input = input.split("\n")
results = []
input.each do |line|
    # convert string to int
    numbers = %w(zero one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen twenty)
    newline = line.dup
    numbers.each do |num|
        # replace the word with the index which is also the number of that word
        newline.gsub!(num, numbers.index(num).to_s)
    end
    nums_in_line = newline.scan(/\d/)
    # this isn't actually adding them its string concatenation
    results << nums_in_line[0] + nums_in_line[-1]
    puts nums_in_line[0] + nums_in_line[-1] + ' | ' + newline
end

total = 0
results.each do |res|
    # here we convert to integer
    total += res.to_i
end

puts "Total: #{total}"