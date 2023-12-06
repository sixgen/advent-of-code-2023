
#!/usr/bin/env ruby

sum = 0

GET_NUMBER = {
    one: 1,
    two: 2,
    three: 3,
    four: 4,
    five: 5,
    six: 6,
    seven: 7,
    eight: 8,
    nine: 9
}

File.readlines('input2', chomp: true).each do |line|
    nums = line.scan(/(?=(one|two|three|four|five|six|seven|eight|nine|\d+))/)
    
    first_num = if nums.first[0].match?(/\d+/)
        nums.first[0].split('').first
    else
        GET_NUMBER[nums.first[0].to_sym]
    end

    last_num = if nums.last[0].match?(/\d+/)
        nums.last[0].split('').last
    else
        GET_NUMBER[nums.last[0].to_sym]
    end

    num = [first_num, last_num].join.to_i

    puts "#{num} | #{line}"

    sum += num
end

puts sum
