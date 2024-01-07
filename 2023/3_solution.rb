# --- Day 3: Gear Ratios ---
# You and the Elf eventually reach a gondola lift station; he says the gondola
# lift will take you up to the water source, but this is as far as he can bring
# you. You go inside.
#
# It doesn't take long to find the gondolas, but there seems to be a problem:
# they're not moving.
#
# "Aaah!"
#
# You turn around to see a slightly-greasy Elf with a wrench and a look of
# surprise. "Sorry, I wasn't expecting anyone! The gondola lift isn't working
# right now; it'll still be a while before I can fix it." You offer to help.
#
# The engineer explains that an engine part seems to be missing from the
# engine, but nobody can figure out which one. If you can add up all the part
# numbers in the engine schematic, it should be easy to work out which part is
# missing.
#
# The engine schematic (your puzzle input) consists of a visual representation
# of the engine. There are lots of numbers and symbols you don't really
# understand, but apparently any number adjacent to a symbol, even diagonally,
# is a "part number" and should be included in your sum. (Periods (.) do not
# count as a symbol.)
#
# Here is an example engine schematic:
#
# 467..114..
# ...*......
# ..35..633.
# ......#...
# 617*......
# .....+.58.
# ..592.....
# ......755.
# ...$.*....
# .664.598..
# In this schematic, two numbers are not part numbers because they are not
# adjacent to a symbol: 114 (top right) and 58 (middle right). Every other
# number is adjacent to a symbol and so is a part number; their sum is 4361.
#
# Of course, the actual engine schematic is much larger. What is the sum of all
# of the part numbers in the engine schematic?

class Schematic
  attr_reader :raw_engine_matrix, :engine_matrix

  def initialize(filename = "3_input.txt")
    @raw_engine_matrix = File.readlines(filename).map { |row| row.strip.split('') }
  end

  def parse_engine_matrix!
    @engine_matrix = raw_engine_matrix.each_with_index.map do |row, row_i|
      row.each_with_index.map do |col, col_i|
        SchematicCell.new(row: row_i, column: col_i, value: col)
      end
    end
  end
end

class SchematicCell
  attr_reader :value, :row, :column, :cell_type

  def initialize(row:, column:, value:)
    @value = value
    @row = row
    @column = column
  end

  def determine_cell_type!
    @cell_type = case value
                 when '.'
                   :blank
                 when /[0-9]/
                   :number
                 when /[a-zA-Z]/
                   :symbol
                 else
                   :symbol
                 end
  end
end
