#/usr/bin/env ruby -wKU

require 'pry'

class Schematic
    def initialize
        @data = []
        @debug = false
        @digits = []
        @gears = []
        @valid_numbers = []
        @valid_ratios = []
        load_data('input')
        process_data
        process_validity
        binding.pry
    end

    def load_data(file_path)
        File.readlines(file_path, chomp: true).each do |line|
            row = line.split('')
            @data.push(row)
        end
    end

    def build_digit_left(row, col)
        looping = true
        number_string = @data[row][col]
        search_col = col
        while looping do
            search_col -= 1
            # loop stops if not a digit
            if @data[row][search_col].to_s.match?(/\d/)
                number_string = "#{@data[row][search_col]}#{number_string}"
                puts "loop| search_col: #{search_col} col: #{col} | num: #{number_string}" if @debug
            else
                search_col += 1
                break
            end
        end

        puts "end loop| search_col: #{search_col} col: #{col} | num: #{number_string}" if @debug
        return number_string, { start_col: search_col, end_col: col, row: row }
    end

    def digit_adjacent_right?(row, col)
        return false if @data[row].length < col + 1
        return true if @data[row][col + 1].to_s.match?(/\d/)
    end

    def process_data
        # processes numbers by finding the right most digit, and then building
        # the number to the left of it.
        @data.each_with_index do |row, row_index|
            row.each_with_index do |col, col_index|
                case col
                when /\d/
                    # note location
                    # is there a digit adjacent to the right? then skip
                    if digit_adjacent_right?(row_index, col_index)
                        next
                    else
                        # no digit to the right, build number
                        n, r = build_digit_left(row_index, col_index)
                        digit = Digit.new(n, r)
                        @digits.push(digit)
                        puts "Number: #{digit.digit}, Location: #{digit.location}"
                    end
                when /\*/
                    @gears.push(Gear.new(row_index, col_index))
                end
            end
        end
    end

    def process_validity
        validity_part1
        validity_part2
    end

    def validity_part1
        @digits.each do |digit|
            valid_number = false
            digit.all_coordinates.each do |coordinate|
                if adjacent_places_are_special?(coordinate[:row], coordinate[:col])
                    valid_number = true
                    break
                end
            end
            if valid_number
                puts "valid number: #{digit.digit}" if @debug
                @valid_numbers.push(digit.digit.to_i)
            end
        end
        puts "Total: #{@valid_numbers.sum}"
    end

    def validity_part2
        # for each gear, get adjancent coordinates. loop through digits to see
        # if digit coordinates match adjacent coordinates. if so, add digit to
        # adjacent_numbers array.
        @gears.each do |gear|
            gear.adjacent_coordinates.each do |coordinate|
                @digits.each do |digit|
                    digit.all_coordinates.each do |digit_coordinate|
                        if coordinate[:row] == digit_coordinate[:row] && coordinate[:col] == digit_coordinate[:col]
                            gear.adjacent_numbers.push(digit)
                        end
                    end
                end
            end
        end

        @gears.select{ |gear| gear.adjacent_numbers.length == 2 }.each do |gear|
            puts gear.adjacent_numbers.map(&:digit).join(' * ')
            gear_ratio = gear.adjacent_numbers[0].digit.to_i * gear.adjacent_numbers[1].digit.to_i
            puts "gear ratio: #{gear_ratio}"
            @valid_ratios.push(gear_ratio)
        end

        puts "Total gear ratio: #{@valid_ratios.sum}"
    end

    def adjacent_places_are_special?(row, col)
        # left right
        return true if special_characters?(row, col + 1)
        return true if special_characters?(row, col - 1)
        # up down
        return true if special_characters?(row + 1, col)
        return true if special_characters?(row - 1, col)
        # diagonals
        return true if special_characters?(row - 1, col - 1)
        return true if special_characters?(row - 1, col + 1)
        return true if special_characters?(row + 1, col + 1)
        return true if special_characters?(row + 1, col - 1)
        # finally
        return false
    end

    def special_characters?(row, col)
        # is within bounds
        return false if out_of_bound?(row, col)
        # TRUE not a digit or a dot
        return true unless @data[row][col].match?(/\d/) || @data[row][col] == '.'
    end

    def out_of_bound?(row, col)
        # not negative
        return true if row < 0 || col < 0
        # not greater than length
        return true if row >= @data.length || col >= @data[row].length
        return false
    end
end

class Digit < Schematic
    attr_accessor :digit, :location
    def initialize(digit, location)
        @digit = digit
        @location = location
    end

    def all_coordinates
        # returns an array of hashes with row and col
        coordinates = []
        cur_loca = @location[:start_col]
        while cur_loca <= @location[:end_col] do
            coordinates.push({ row: @location[:row], col: cur_loca })
            cur_loca += 1
        end
        return coordinates
    end
end

class Gear < Schematic
    attr_accessor :row, :col, :adjacent_numbers
    def initialize(row, col)
        @row = row
        @col = col
        @adjacent_numbers = []
    end

    def adjacent_coordinates
        [
            # left right
            {row: @row, col: @col + 1},
            {row: @row, col: @col - 1},
            # up down
            {row: @row + 1, col: @col},
            {row: @row - 1, col: @col},
            # diagonals
            {row: @row - 1, col: @col - 1},
            {row: @row - 1, col: @col + 1},
            {row: @row + 1, col: @col + 1},
            {row: @row + 1, col: @col - 1}
        ]
    end

    def digit?(row, col)
        return true if @data[row][col].to_s.match?(/\d/)
    end
end

scheme = Schematic.new
