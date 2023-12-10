sum = 0

File.readlines('part1_input', chomp: true).each do |line|
    card = line.gsub(/Card \d+:/, '').split('|')

    winning_nums = card[0].split(' ')
    players_nums = card[1].split(' ')
    
    players_wins = 0
    players_nums.each do |num|   
        winning_nums.each do |winning_num|
            if num == winning_num
                players_wins += 1
            end
        end
    end

    points = 0
    if players_wins == 1
        points = 1
    elsif players_wins == 2
        points = 2
    elsif players_wins > 2
        points = 2 ** (players_wins - 1)
    end

    puts "players_wins: #{players_wins} points for this round: #{points}"
    sum += points
end

puts sum