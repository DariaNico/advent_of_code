# As you walk, the Elf shows you a small bag and some cubes which are either
# red, green, or blue. Each time you play this game, he will hide a secret
# number of cubes of each color in the bag, and your goal is to figure out
# information about the number of cubes.
#
# To get information, once a bag has been loaded with cubes, the Elf will reach
# into the bag, grab a handful of random cubes, show them to you, and then put
# them back in the bag. He'll do this a few times per game.
#
# You play several games and record the information from each game (your puzzle
# input). Each game is listed with its ID number (like the 11 in Game 11: ...)
# followed by a semicolon-separated list of subsets of cubes that were revealed
# from the bag (like 3 red, 5 green, 4 blue).
#
# For example, the record of a few games might look like this:
#
# ```
# Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
# Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
# Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
# Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
# Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
# ```
# In game 1, three sets of cubes are revealed from the bag
# (and then put back again). The first set is 3 blue cubes and 4 red cubes; the
# second set is 1 red cube, 2 green cubes, and 6 blue cubes; the third set is
# only 2 green cubes.
#
# The Elf would first like to know which games would have been possible if the
# bag contained only
# `12 red cubes, 13 green cubes, and 14 blue cubes?`
#
# In the example above, games 1, 2, and 5 would have been possible if the bag
# had been loaded with that configuration. However, game 3 would have been
# impossible because at one point the Elf showed you 20 red cubes at once;
# similarly, game 4 would also have been impossible because the Elf showed you
# 15 blue cubes at once. If you add up the IDs of the games that would have
# been possible, you get 8.
#
# Determine which games would have been possible if the bag had been loaded
# with only `12 red cubes, 13 green cubes, and 14 blue cubes`. What is the sum of
# the IDs of those games?

class GameBag
  attr_accessor :initial_cubes, :inputs, :games, :illegal_games, :legal_games

  def initialize(filename:, initial_cubes: { red: 12, green: 13, blue: 14 })
    @initial_cubes = initial_cubes
    @inputs = File.readlines(filename).map(&:chomp)
    @games = {}
    @illegal_games = []
    @legal_games = []

    parse_inputs
    check_games
  end

  def sum_legal_games
    legal_games.reduce(&:+)
  end

  def parse_inputs
    inputs.each do |game|
      game_number, game_parts = split_and_strip(':').call(game)
      game_number = split_and_strip(' ').call(game_number).last.to_i

      game_parts = split_and_strip(';').call(game_parts)
      game_parts.map! do |game_part|
        block_breakdown = {}
        drawn_blocks = split_and_strip(',').call(game_part)
        drawn_blocks.each do |drawn_block|
          number_drawn, color_drawn = drawn_block.split(' ')
          block_breakdown[color_drawn.to_sym] = number_drawn.to_i
        end

        block_breakdown
      end

      @games[game_number] = game_parts
    end
  end

  def check_games
    games.each do |game_number, game_parts|
      game_parts.each do |game_part|
        if !game_part_valid?(game_part)
          @illegal_games << game_number
          next
        end
      end

      unless illegal_games.include?(game_number)
        @legal_games << game_number
      end
    end
  end

  def check_game_parts(game_parts)
    game_parts.each do |game_part|
      is_valid = game_part_valid?(game_part)
      if !is_valid
        puts "Invalid game:"
        puts "check: #{initial_cubes}"
        puts "gamepart: #{game_part}"
      end
    end
  end

  def game_part_valid?(game_part)
    valid = true

    [:red, :green, :blue].each do |color_sym|
      valid = valid && color_number_valid?(color_sym).call(game_part)
    end

    valid
  end

  def color_number_valid?(color_sym)
    Proc.new do |game_part|
      number_of_color_drawn = game_part[color_sym] || 0
      number_of_color_drawn <= initial_cubes[color_sym]
    end
  end

  def split_and_strip(split_char)
    Proc.new { |string| string.split(split_char).map(&:strip) }
  end
end
