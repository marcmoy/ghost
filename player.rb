class Player
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def guess
    letter = ""
    loop do
      print "#{name}, enter your guess: "
      letter = gets.chomp
      break if valid_guess(letter)
      puts "Invalid input; try again."
      sleep 3
    end
    letter
  end

  def alert_invalid_guess
    puts "Invalid input, please try again!"
    sleep 3
  end

  private

  def valid_guess(letter)
    letter.match(/[a-z]/i) != nil && letter.length == 1
  end

end
