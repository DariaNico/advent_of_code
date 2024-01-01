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
          { red: 0, green: 12, blue: 10 },
        ]
      }

      it "creates a game with accessible game_number" do
        expect(game.game_number).to eq(game_number)
      end

      it "creates a game with accessible draws" do
        expect(game.draws).to eq(draws)
      end

      it "creates a game with accessible cube_colors" do
        expect(game.cube_colors).to eq(draws)
      end
    end
  end

  describe "#attributes" do

    it "returns a hash with all instance variables as keys and their values" do
      expected_attr_hash = { game_number: game_number, draws: draws }

      expect(game.attributes).to eq(expected_attr_hash)
    end
  end
end

describe GameBag do
  let(:filename) { "test_text.txt" }
  let(:initial_cubes) { { red: 3, green: 3, blue: 3 } }
  let(:file_input) { [
    " Game 1: 1 red, 2 green, 3 blue; 5 red, 4 blue, 1 green; 2 green, 17 red, 6 blue; 5 green, 1 blue, 11 red; 18 red, 1 green, 14 blue; 8 blue",
    "  Game 2: 16 blue, 12 green, 3 red; 13 blue, 2 red, 8 green; 15 green, 3 red, 16 blue  ",
    "Game 3: 6 green, 15 red; 1 green, 4 red, 7 blue; 9 blue, 7 red, 8 green ",
  ] }
  let(:game_bag) { GameBag.new(filename: filename, initial_cubes: initial_cubes) }

  before(:each) do
    allow(File).to receive(:readlines).and_return(file_input)
  end

  describe "#initialize" do
    context "given valid arguments" do
      it "creates a game bag with the given initial_cubes arg" do
        expect(game_bag.initial_cubes).to eq(initial_cubes)
      end

      let(:expected_raw_inputs) { [
        "Game 1: 1 red, 2 green, 3 blue; 5 red, 4 blue, 1 green; 2 green, 17 red, 6 blue; 5 green, 1 blue, 11 red; 18 red, 1 green, 14 blue; 8 blue",
        "Game 2: 16 blue, 12 green, 3 red; 13 blue, 2 red, 8 green; 15 green, 3 red, 16 blue",
        "Game 3: 6 green, 15 red; 1 green, 4 red, 7 blue; 9 blue, 7 red, 8 green",
      ] }
      it "creates a GameBag with raw_inputs array of every line without trailing whitespaces" do
        expect(game_bag.inputs).to eq(expected_raw_inputs)
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
      }
    }
    let(:expected_game_6_attrs) {
      {
        game_number: 6,
        draws: [
          { red: 15, green: 6, blue: 100 },
        ],
        cube_colors: cube_colors,
      }
    }
    let(:expected_game_7_attrs) {
      {
        game_number: 7,
        draws: [
          { red: 3, green: 12, blue: 16 },
        ],
        cube_colors: cube_colors,
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
        }
      }
      let(:expected_game_6_attrs) {
        {
          game_number: 6,
          draws: [
            { red: 15, green: 6, blue: 100 },
          ],
          cube_colors: cube_colors,
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

end
