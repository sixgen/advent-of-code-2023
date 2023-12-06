#!/usr/bin/env ruby

# Determine which games would have been possible if the bag had been loaded with only 12 red cubes, 13 green cubes, and 14 blue cubes. 
# What is the sum of the IDs of those games?

GAME_CHOICES = {
    red: 12,
    green: 13,
    blue: 14
}

games = Hash.new
File.readlines('game_input', chomp: true).each_with_index do |line, game_num|
    game_sets = {}
    line.gsub(/Game \d+: /,'').split(';').each_with_index do |game, game_set|
        game_sets["Set #{game_set+1}"] = game
    end
    games["Game #{game_num+1}"] = game_sets
    #reds   = line.scan(/\d+ red/).map! {|item| item.gsub(' red', '')}
end

games.each do |game|
    puts "game is #{game}"
end