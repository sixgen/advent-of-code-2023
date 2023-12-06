#!/usr/bin/env ruby

game_limit = {
    red: 12,
    green: 13,
    blue: 14
}
answer = 0

def game_bool(game_results, game_limit)
    game_results.each do |game|
        game.scan(/(\d+)\s(\w+)/).each do |score, color|
            if score.to_i > game_limit[color.to_sym]
                return false
            end
        end
    end
    return true
end

File.readlines('input', chomp: true).each do |line|
    game_string, game_input = line.split(':')
    game_id = game_string.split(' ')[1]
    # puts "game_string: #{game_string}"
    # puts "game_input: #{game_input}"
    game_results = game_input.split(';')
    # determine game limit from game_results
    game_bool(game_results, game_limit) ? answer += game_id.to_i : next
end

puts answer