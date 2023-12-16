# --- Day 1: Trebuchet?! ---
# The newly-improved calibration document consists of lines of text; each
# line originally contained a specific calibration value that the Elves now
# need to recover. On each line, the calibration value can be found by
# combining the first digit and the last digit (in that order) to form a
# single two-digit number.
# For example:
#   jj6sevenine => 66 
#   oneeight6shru249 => 69
#
# --- Part Two ---
# Your calculation isn't quite right. It looks like some of the digits are
# actually spelled out with letters: one, two, three, four, five, six, seven,
# eight, and nine also count as valid "digits".
#
# Equipped with this new information, you now need to find the real first and
# last digit on each line. For example:
#   jj6sevenine => 69 
#   oneeight6shru249 => 19

class DayOneCalibration
  attr_reader :calibrations

  def initialize(filepath = "")
    @calibrations = []

    File.open(filepath, 'r') do |f|
      f.each_line do |line|
        @calibrations << line.
          gsub(words_number_match, words_number_hash).
          gsub(words_number_match, words_number_hash).
          gsub(/\D/, '')
      end
    end
  end

  def words_number_match
    /one|two|three|four|five|six|seven|eight|nine/
  end

  def words_number_hash
    {
      'one' => 'o1e',
      'two' => 't2o',
      'three' => 't3e',
      'four' => 'f4r',
      'five' => 'f5e',
      'six' => 's6x',
      'seven' => 's7n',
      'eight' => 'e8t',
      'nine' => 'n9e',
    }
  end

  def get_calabration_int(calabration_string)
    puts calabration_string
    (calabration_string[0] + calabration_string[-1]).to_i
  end

  def calabration_sum
    calibrations.reduce(0) { |sum, calabration| sum + get_calabration_int(calabration) }
  end
end
