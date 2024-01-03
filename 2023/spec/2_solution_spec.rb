require "./2_solution"

describe Game do
  let(:game_number) { 1 }
  let(:draws) {
    [
      { red: 0, green: 1, blue: 10 },
    ]
  }
  let(:cube_colors) { [:red, :green, :blue] }
  let(:game) { Game.new(game_number: game_number, draws: draws, cube_colors: cube_colors) }

  describe "#initialize" do
    context "given a game number and a draws array" do
      let(:game_number) { 42 }
      let(:draws) {
        [
          { red: 1, green: 2, blue: 3 },
          { green: 1, blue: 1 },
        ]
      }

      it "creates a game with accessible game_number" do
        expect(game.game_number).to eq(game_number)
      end

      it "creates a game with accessible draws" do
        expect(game.draws).to eq(draws)
      end

      it "creates a game with accessible cube_colors" do
        expect(game.cube_colors).to eq(cube_colors)
      end

      it "creates a game with accessible minimum_valid_cubes" do
        expect(game.minimum_valid_cubes).to eq({ red: 1, green: 2, blue: 3 })
      end
    end
  end

  describe "#attributes" do
    it "returns a hash with all instance variables as keys and their values" do
      expected_attr_hash = { game_number: game_number,
                             draws: draws,
                             cube_colors: cube_colors,
                             minimum_valid_cubes: draws.first }

      expect(game.attributes).to eq(expected_attr_hash)
    end
  end

  describe "#calculate_minimum_valid_cubes!" do
    context "given a game with multiple draws" do
      context "and every draw has all the colors" do
        let(:draws) {
          [
            { blue: 2, green: 12, red: 1 },
            { red: 5, green: 1, blue: 2 },
            { red: 50, green: 11, blue: 22 },
          ]
        }

        it "calculates the min cube count needed for the game to be valid and saves it in @minimum_valid_cubes" do
          game.calculate_minimum_valid_cubes!
          expect(game.minimum_valid_cubes).to eq({ red: 50, green: 12, blue: 22 })
        end
      end

      context "and some draws don't have all rgb colors" do
        let(:draws) {
          [
            { green: 12, red: 1 },
            { red: 5 },
          ]
        }

        it "calculates the min cube count needed for the game to be valid (with 0s as needed) and saves it in @minimum_valid_cubes" do
          game.calculate_minimum_valid_cubes!
          expect(game.minimum_valid_cubes).to eq({ red: 5, green: 12, blue: 0 })
        end
      end
    end

    context "given a game with no draws" do
      let(:draws) { [] }

      it "returns 0 for all rgb colors" do
        game.calculate_minimum_valid_cubes!
        expect(game.minimum_valid_cubes).to eq({ red: 0, green: 0, blue: 0 })
      end
    end
  end

  describe "#power" do
    let(:draws) { [min_valid_cube_mock] }

    before(:each) do
      allow(Game).to receive(:minimum_valid_cubes).and_return(min_valid_cube_mock)
    end

    context "given all minimum_valid_cubes are 1" do
      let(:min_valid_cube_mock) { { red: 1, green: 1, blue: 1 } }

      it "calculates the power out to be 1" do
        expect(game.power).to eq(1)
      end
    end

    context "given minimum_valid_cubes are greater than 1" do
      let(:min_valid_cube_mock) { { red: 2, green: 3, blue: 10 } }

      it "calculates the power out to be their multiplied power together when values greater than 1" do
        expect(game.power).to eq(60)
      end
    end

    context "given minimum_valid_cubes that contain a zero for a game" do
      let(:min_valid_cube_mock) { { red: 1, green: 0, blue: 1 } }

      it "calculates the power out to be 0" do
        expect(game.power).to eq(0)
      end
    end
  end
end

# Improvement: Maybe make this color agnostic?
describe GameBag do
  let(:filename) { "test_text.txt" }
  let(:initial_cubes) { { red: 9, green: 9, blue: 9 } }
  let(:file_input) { [
    " Game 1: 1 red, 2 green, 3 blue; 5 red, 4 blue, 1 green; 2 green, 17 red, 6 blue; 5 green, 1 blue, 11 red; 18 red, 1 green, 14 blue; 8 blue",
    "  Game 2: 16 blue, 12 green, 3 red; 13 blue, 2 red, 8 green; 15 green, 3 red, 16 blue  ",
    "Game 3: 6 green, 1 red; 1 green, 4 red, 7 blue; 9 blue, 7 red, 8 green ",
  ] }
  let(:game_bag) { GameBag.new(filename: filename, initial_cubes: initial_cubes) }

  before(:each) do
    allow(File).to receive(:readlines).and_return(file_input)
  end

  describe "#initialize" do
    context "given valid arguments" do
      let(:expected_raw_inputs) { [
        "Game 1: 1 red, 2 green, 3 blue; 5 red, 4 blue, 1 green; 2 green, 17 red, 6 blue; 5 green, 1 blue, 11 red; 18 red, 1 green, 14 blue; 8 blue",
        "Game 2: 16 blue, 12 green, 3 red; 13 blue, 2 red, 8 green; 15 green, 3 red, 16 blue",
        "Game 3: 6 green, 1 red; 1 green, 4 red, 7 blue; 9 blue, 7 red, 8 green",
      ] }

      it "creates a game bag with the given initial_cubes arg" do
        expect(game_bag.initial_cubes).to eq(initial_cubes)
      end

      it "creates a GameBag with raw_inputs array of every line without trailing whitespaces" do
        expect(game_bag.inputs).to eq(expected_raw_inputs)
      end

      context "populating @games" do
        it "populates @games with parse_game_inputs!" do
          test_game_bag = GameBag.allocate
          expect(test_game_bag).to receive(:parse_game_inputs!)
          test_game_bag.send(:initialize, filename: filename)
        end

        it "correctly populates @games hash with int => Game" do
          expect(game_bag.games.keys).to eq([1, 2, 3])
          expect(game_bag.games.values.map(&:class)).to eq([Game, Game, Game])
        end
      end

      it "populates @valid_game_numbers" do
        expect(game_bag.valid_game_numbers).to eq([3])
      end
    end
  end

  describe("#parse_game_inputs!") do
    let(:file_input) { [
      "Game 5: 1 red, 2 green, 3 blue; 5 red, 4 blue, 1 green",
      "Game 7: 16 blue, 12 green, 3 red",
      "Game 6: 6 green, 15 red, 100 blue",
    ] }
    let(:cube_colors) { [:red, :green, :blue] }

    let(:expected_game_5_attrs) {
      {
        game_number: 5,
        draws: [
          { red: 1, green: 2, blue: 3 },
          { red: 5, green: 1, blue: 4 },
        ],
        cube_colors: cube_colors,
        minimum_valid_cubes: { red: 5, green: 2, blue: 4 },
      }
    }
    let(:expected_game_6_attrs) {
      {
        game_number: 6,
        draws: [
          { red: 15, green: 6, blue: 100 },
        ],
        cube_colors: cube_colors,
        minimum_valid_cubes: { red: 15, green: 6, blue: 100 },
      }
    }
    let(:expected_game_7_attrs) {
      {
        game_number: 7,
        draws: [
          { red: 3, green: 12, blue: 16 },
        ],
        cube_colors: cube_colors,
        minimum_valid_cubes: { red: 3, green: 12, blue: 16 },
      }
    }

    it "populates games with Game objects of the correct game_number and draws" do
      expected_games_attrs = [ [5, expected_game_5_attrs],
                               [6, expected_game_6_attrs],
                               [7, expected_game_7_attrs], ]
      game_bag.parse_game_inputs!
      games_attrs = game_bag.games.map { |k, v| [k, v.attributes] }.sort

      expect(games_attrs).to eq(expected_games_attrs)
    end

    context "given inputs of the same game number" do
      let(:file_input) { [
        "Game 5: 1 red, 2 green, 3 blue; 5 red, 4 blue, 1 green",
        "Game 5: 16 blue, 12 green, 3 red",
        "Game 6: 6 green, 15 red, 100 blue",
      ] }
      let(:expected_game_5_attrs) {
        {
          game_number: 5,
          draws: [
            { red: 1, green: 2, blue: 3 },
            { red: 5, green: 1, blue: 4 },
          ],
          cube_colors: cube_colors,
          minimum_valid_cubes: { red: 5, green: 2, blue: 4 },
        }
      }
      let(:expected_game_6_attrs) {
        {
          game_number: 6,
          draws: [
            { red: 15, green: 6, blue: 100 },
          ],
          cube_colors: cube_colors,
          minimum_valid_cubes: { red: 15, green: 6, blue: 100 },
        }
      }

      it "saves the first given game only" do
        expected_games_attrs = [ [5, expected_game_5_attrs],
                                 [6, expected_game_6_attrs], ]
        game_bag.parse_game_inputs!
        games_attrs = game_bag.games.map { |k, v| [k, v.attributes] }.sort

        expect(games_attrs).to eq(expected_games_attrs)
      end
    end
  end

  describe "#valid_game?" do
    context "given a game with minimum_valid_cubes all less than initial_cubes" do
      let(:game) { Game.new(game_number: 1, draws: [ { red: 1, green: 2, blue: 3 } ]) }
      let(:initial_cubes) { { red: 2, green: 3, blue: 4 } }

      it "is valid and returns true" do
        expect(game_bag.valid_game?(game)).to be_truthy
      end
    end

    context "given a game with minimum_valid_cubes equal to initial_cubes" do
      let(:game) { Game.new(game_number: 1, draws: [ { red: 1, green: 2, blue: 3 } ]) }
      let(:initial_cubes) { { red: 1, green: 2, blue: 3 } }

      it "is invalid and returns false" do
        expect(game_bag.valid_game?(game)).to be_truthy
      end
    end

    context "given a game with some minimum_valid_cubes greater than initial_cubes" do
      let(:game) { Game.new(game_number: 1, draws: [ { red: 1, green: 200, blue: 3 } ]) }
      let(:initial_cubes) { { red: 1, green: 2, blue: 3 } }

      it "is invalid and returns false" do
        expect(game_bag.valid_game?(game)).to be_falsey
      end
    end
  end

  describe "#find_valid_games!" do
    context "given a mix of valid and invalid games in the game bag" do
      let(:file_input) { [
        "Game 2: 1 blue, 1 green, 1 red",
        "Game 3: 2 green, 1 red, 1 blue",
        "Game 5: 2 green, 2 red, 2 blue",
        "Game 1: 100 red, 2 green, 3 blue; 5 red, 4 blue, 1 green",
        "Game 4: 6 green, 15 red, 100 blue",
      ] }
      let(:initial_cubes) { { red: 2, green: 3, blue: 4 } }

      it "adds the valid game_numbers to @valid_game_numbers sorted" do
        game_bag.find_valid_games!

        expect(game_bag.valid_game_numbers).to eq([2, 3, 5])
      end

      it "is idempotent" do
        game_bag.find_valid_games!
        game_bag.find_valid_games!
        game_bag.find_valid_games!

        expect(game_bag.valid_game_numbers).to eq([2, 3, 5])
      end
    end
  end

  describe "#sum_valid_game_numbers" do
    let(:file_input) { [
      "Game 1: 1 red, 2 green, 3 blue; 5 red, 4 blue, 1 green",
      "Game 10: 16 blue, 1200 green, 3 red",
      "Game 100: 6 green, 10 red, 10 blue",
    ] }
    let(:initial_cubes) { { red: 10, green: 10, blue: 10 } }

    it "adds together the valid game's game_numbers" do
      expect(game_bag.sum_valid_game_numbers).to eq(101)
    end
  end

  describe "#sum_game_powers" do
    let(:file_input) { [
      "Game 100: 1 red, 2 green, 3 blue", # power = 6
      "Game 1000: 2 blue, 2 green, 3 red", # power = 12
      "Game 1: 3 green, 3 red, 10 blue", # power = 90
    ] }

    it "adds together the powers of all the games" do
      expect(game_bag.sum_game_powers).to eq(108)
    end
  end
end
