require "./2_solution"
# require 'debug'; binding.break

describe Game do
  let(:game_number) { 1 }
  let(:draws) {
    [
      { red: 0, green: 1, blue: 10 },
    ]
  }
  let(:game) { Game.new(game_number: game_number, draws: draws) }

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
    end
  end

  describe "#attributes" do
    let(:expected_attr_hash) { { game_number: game_number, draws: draws } }

    it "returns a hash with all instance variables as keys and their values" do
      expect(game.attributes).to eq(expected_attr_hash)
    end
  end

end

describe GameBag do

end
