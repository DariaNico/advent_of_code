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
  attr_reader :raw_engine_matrix, :engine_matrix, :max_coordinate

  def initialize(filename = "3_input.txt")
    @raw_engine_matrix = File.readlines(filename).map { |row| row.strip.split('') }
    @max_coordinate = [raw_engine_matrix.length - 1, raw_engine_matrix.first.length - 1]

    parse_engine_matrix!
    populate_matrix_neighbors!
  end

  def parse_engine_matrix!
    @engine_matrix = raw_engine_matrix.each_with_index.map do |row, row_i|
      row.each_with_index.map do |col, col_i|
        create_cell(coordinates: [row_i, col_i],
                    value: col)
      end
    end
  end

  def populate_matrix_neighbors!
    engine_matrix.flatten.each do |schematic_cell|
      if [:number, :symbol].include?(schematic_cell.cell_type)
        neighbors = schematic_cell.
          all_neighbor_coordinates.
          map { |coordinates| find_cell(coordinates) }
        schematic_cell.neighbors = neighbors.compact
      end
    end
  end

  def find_cell(coordinates)
    engine_matrix[coordinates.first][coordinates.last]
  end

  def create_cell(coordinates:, max_coord: max_coordinate, value: '.')
    SchematicCell.new(row: coordinates.first,
                      column: coordinates.last,
                      value: value,
                      max_coordinate: max_coord)
  end

  def get_part_number_value(number_cell)
    if !!number_cell.part_number_value
      number_cell.part_number_value
    elsif number_cell.part_number? && number_cell.part_number_value.nil?
      left_cell = number_cell.left_neighbor
      right_cell = number_cell.right_neighbor

      number_value = number_cell.value
      cells_to_update = [number_cell]

      while left_cell && left_cell.cell_type == :number do
        number_value = "#{left_cell.value}#{number_value}"
        cells_to_update << left_cell
        left_cell = left_cell.left_neighbor
      end

      while right_cell && right_cell.cell_type == :number do
        number_value = "#{number_value}#{right_cell.value}"
        cells_to_update << right_cell
        right_cell = right_cell.right_neighbor
      end

      number_value = number_value.to_i
      update_cells_part_number_value(cells_to_update, number_value)

      number_value
    end
  end

  def update_cells_part_number_value(cells, part_number_value)
    cells.each do |cell|
      cell.part_number_value = part_number_value
    end
  end
end

class SchematicCell
  attr_reader :cell_type, :column, :max_coordinate, :row, :value
  attr_accessor :neighbors, :part_number_value

  def initialize(row:, column:, value:, max_coordinate:)
    @column = column
    @max_coordinate = max_coordinate
    @row = row
    @value = value
    determine_cell_type!
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

  def coordinates
    [row, column]
  end

  def row_neighbor_coordinates(neighbor_row = row)
    ((column - 1)..(column + 1)).map { |neighbor_col|
      if row_valid?(neighbor_row) && column_valid?(neighbor_col)
        [neighbor_row, neighbor_col]
      end
    }.compact
  end

  def all_neighbor_coordinates
    ((row - 1)..(row + 1)).map { |neighbor_row|
      row_neighbor_coordinates(neighbor_row)
    }.flatten(1)
  end

  def similar_to?(schematic_cell)
    schematic_cell.value == value &&
    schematic_cell.coordinates == coordinates &&
    schematic_cell.max_coordinate == max_coordinate
  end

  def left_neighbor
    neighbors.select { |neighbor|
      neighbor.coordinates == [row, column - 1]
    }.first
  end

  def right_neighbor
    neighbors.select { |neighbor|
      neighbor.coordinates == [row, column + 1]
    }.first
  end

  def part_number?
    part_number_value ||
      cell_type == :number &&
      neighbors.any? { |neighbor| neighbor.cell_type == :symbol }
  end


  private

  def row_valid?(row_coord = row)
    0 <= row_coord && row_coord <= max_coordinate.first
  end

  def column_valid?(column_coord = column)
    0 <= column_coord && column_coord <= max_coordinate.last
  end
end
