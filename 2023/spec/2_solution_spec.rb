require "./2_solution"
# require 'debug'; binding.break

describe Game do
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

end

describe GameBag do

end
