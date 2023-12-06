#!/usr/bin/env ruby

def determine_game_limit(game_id, game_results)
    game_output = {
        id: 0,
        red: 0,
        green: 0,
        blue: 0
    }
    game_output[:id] = game_id
    game_results.each do |game|
        game.scan(/(\d+)\s(\w+)/).each do |score, color|
            game_output[color.to_sym] = score.to_i if score.to_i > game_output[color.to_sym]
        end
    end
    return game_output
end

answer = 0

File.readlines('input', chomp: true).each do |line|
    game_string, game_input = line.split(':')
    game_id = game_string.split(' ')[1]
    # puts "game_string: #{game_string}"
    # puts "game_input: #{game_input}"
    game_results = game_input.split(';')
    # determine game limit from game_results
    game_output = determine_game_limit(game_id, game_results)
    puts "game_output: #{game_output}"
    final = game_output[:red] * game_output[:green] * game_output[:blue]
    puts "final: #{final}"
    answer = answer + final
end

puts answer