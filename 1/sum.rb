
#!/usr/bin/env ruby

sum = 0

File.readlines('input1', chomp: true).each do |line|
    first_num = Integer(line.scan(/\d+/).first.split('').first)
    second_num = Integer(line.scan(/\d+/).last.split('').last)
    num =  [first_num, second_num].join.to_i
    sum += num
end

puts sum