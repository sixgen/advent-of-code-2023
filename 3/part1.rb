#/usr/bin/env ruby -wKU

class Schematic
    def initialize
        @data = []
        @debug = true
        @digits = []
        @valid_numbers = []
        load_data('input')
        process_data
        puts @valid_numbers
        puts "Total: #{@valid_numbers.sum}"
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
                        puts "digit: #{digit.digit}, range: #{digit.location}"
                        valid_number = false
                        digit.all_coordinates.each do |coordinate|
                            if adjacent_places_are_special?(coordinate[:row], coordinate[:col])
                                valid_number = true
                                break
                            end
                        end
                        if valid_number
                            puts "valid number: #{digit.digit}"
                            @valid_numbers.push(digit.digit.to_i)
                        end
                    end
                end
            end
        end
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

scheme = Schematic.new
