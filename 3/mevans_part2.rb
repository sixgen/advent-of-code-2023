#!/usr/bin/env ruby

@sum = 0

def special_character(char)
    return true if char == '*'
end

def num(x, y)
    left_digits = []
    right_digits = []
    num_coordinates = [[x, y]]

    iterator = 1

    keep_going_left = true
    while(keep_going_left && y-iterator >= 0)
      if @grid[x][y-iterator].match?(/\d+/)
         left_digits.push(@grid[x][y-iterator])
         num_coordinates.push([x, y-iterator])
      else
        keep_going_left = false
      end
    iterator += 1
    end

    iterator = 1

    keep_going_right = true
    while(keep_going_right && y+iterator < @grid[x].size)
      if @grid[x][y+iterator].match?(/\d+/)
        right_digits.push(@grid[x][y+iterator])
        num_coordinates.push([x, y+iterator])

      else
        keep_going_right = false
      end
    iterator += 1
    end

    num = left_digits.reverse.join + @grid[x][y] + right_digits.join
    return num, num_coordinates.sort
end

def adj_nums(x, y)
    nums = {}
    # check above
    if @grid[x-1][y].match?(/\d+/)
        #puts "checking above"
        num = num(x-1, y)
        nums[num] = num[0] unless nums.key?(num) && nums[num] == num[0]
        #puts "found one above and determined full num is #{num}"
    end

    # check above and to the left
    if @grid[x-1][y-1].match?(/\d+/)
       # puts "checking above and to the left"
        num = num(x-1, y-1)
        nums[num] = num[0] unless nums.key?(num) && nums[num] == num[0]
        #puts "found one above and to the left and determined full num is #{num}"
    end

    # check above and to the right
    if @grid[x-1][y+1].match?(/\d+/)
       # puts "checking above and to the right"
        num = num(x-1, y+1)
        nums[num] = num[0] unless nums.key?(num) && nums[num] == num[0]
        #puts "found one above and to the right and determined full num is #{num}"
    end

    # check to the left
    if @grid[x][y-1].match?(/\d+/)
       # puts "checking to the left"
        num = num(x, y-1)
        nums[num] = num[0] unless nums.key?(num) && nums[num] == num[0]
        #puts "found one to the left and determined full num is #{num}"
    end

    # check to the right
    if @grid[x][y+1].match?(/\d+/)
       # puts "checking to the right for #{@grid[x][y+1]}"
        num = num(x, y+1)
        nums[num] = num[0] unless nums.key?(num) && nums[num] == num[0]
       # puts "found one to the right and determined full num is #{num}"
    end

    # check below 
    if @grid[x+1][y].match?(/\d+/)
       # puts "checking below"
        num = num(x+1, y)
        nums[num] = num[0] unless nums.key?(num) && nums[num] == num[0]
       # puts "found one below and to the left and determined full num is #{num}"
    end

    # check below and to the left
    if @grid[x+1][y-1].match?(/\d+/)
       # puts "checking below and to the left"
        num = num(x+1, y-1)
        nums[num] = num[0] unless nums.key?(num) && nums[num] == num[0]
       # puts "found one below and determined full num is #{num}"
    end

    # check below  and to the right
    if @grid[x+1][y+1].match?(/\d+/)
        #puts "checking below and to the right"
        num = num(x+1, y+1)
        nums[num] = num[0] unless nums.key?(num) && nums[num] == num[0]
        #puts "found one below and to the right and determined full num is #{num}"
    end

    keys = []
    if nums.size > 1
        nums.each do |key, value|
        keys.push(value.to_i)
        end
    end
    @sum += keys.inject(:*) unless keys.empty?
    puts "keys: #{keys}"
end

@grid = File.readlines('input', chomp: true).map { |str| str.split('') }
@grid.each_with_index do |row, r_index|
    row.each_with_index do |char, c_index|
        next unless special_character(char)
        puts "found special char #{char} where x, y = (#{r_index}, #{c_index})"
        adj_nums(r_index, c_index)
    end
end

puts  "\nGrid:\n\n"
@grid.each do |x|
  puts x.join(" ")
end

puts "\nSum: #{@sum}"