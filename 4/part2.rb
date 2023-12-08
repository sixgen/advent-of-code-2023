@results = {}
File.readlines('part2_input', chomp: true).each_with_index do |line, index|
  card = line.gsub(/Card \d+:/, '').split('|')

  winning_nums = card[0].split(' ')
  players_nums = card[1].split(' ')

  player_copies = []
  copy = index + 1
  players_nums.each do |num|
    winning_nums.each do |winning_num|
      if num == winning_num
        copy += 1
        player_copies.push(copy)
      end
    end
  end

  @results[index + 1] = player_copies
  puts "results for this round: #{player_copies}"
end

@copies = 0
def copies(card)
  @copies += 1
  @results[card].each do |copy|
    copies(copy)
  end
end

@results.each do |card, copies|
  puts "card #{card} copies #{copies}"
  copies(card)
end

puts "@copies #{@copies}"
