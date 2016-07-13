require_relative 'player'

class Game

  attr_accessor :player1, :player2, :fragment, :dictionary, :current_player, :previous_player, :losses, :idx, :round

  def initialize(player1, player2, filename)
    @player1 = player1
    @player2 = player2
    @current_player = @player1
    @previous_player = @player2
    @fragment = ""
    @losses = { player1.name => 0, player2.name => 0 }
    @idx = 0
    @round = 1
    read_dictionary_txt(filename)
  end

  def run
    loop do
      play_round
      reset_game
      break if game_over?
    end
    display_winner
  end

  def display_winner
    losses.each do |player, losses|
      puts "Winner is: #{player}!" if losses != 5
    end
  end

  def game_over?
    losses.each do |player, losses|
      return true if losses == 5
    end
    false
  end

  def play_round
    loop do
      take_turn(current_player)
      next_player!
      break if round_over?
    end
    record_loss(previous_player)
  end

  # private

  def reset_game
    @fragment = ""
    @idx = 0
    @round += 1
  end

  def record_loss(player)
    puts "#{player.name} lost this round!"
    sleep 3
    @losses[player.name] += 1
  end

  def read_dictionary_txt(filename)
    @dictionary = []
    IO.readlines(filename).each do |word|
      dictionary << word.chomp
    end
  end

  def next_player!
    @current_player, @previous_player = @previous_player, @current_player
  end

  def take_turn(player)
    string = ""
    loop do
      system('clear')
      display_standings
      letter = player.guess
      string = fragment + letter
      break if valid_play?(string)
      player.alert_invalid_guess
    end
    @fragment = string
  end

  def round_over?
    dictionary.include?(fragment) && fragment.length >= 3
  end

  def valid_play?(string)
    dictionary[idx..-1].each_with_index do |word, i|
      if word.match(/^#{string}/) != nil
        @idx += i
        return true
      end
    end
    false
  end

  def display_standings
    puts "Round #{round}"
    puts "#{player1.name}: #{display_ghost(losses[player1.name])}"
    puts "#{player2.name}: #{display_ghost(losses[player2.name])}"
    puts "#{fragment}"
  end

  def display_ghost(losses)
    return "" if losses == 0
    "GHOST"[0..losses-1]
  end

end


if __FILE__ == $PROGRAM_NAME
  p1 = Player.new('IChung')
  p2 = Player.new('Marc')
  game = Game.new(p1,p2,'dictionary.txt')
  game.run
end
