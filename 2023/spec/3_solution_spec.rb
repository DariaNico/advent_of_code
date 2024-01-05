require "./3_solution"

describe Schematic do
  let(:filename) { "test_engine_schema_file.txt" }
  let(:file_input) { [
    "467..114..",
    "...*......",
    "..35..633.",
    "......#...",
    "617*......",
  ] }
  let(:schematic) { Schematic.new(filename) }

  before(:each) do
    allow(File).to receive(:readlines).and_return(file_input)
  end

  describe "#initialize" do
    context "given a valid engine schematic" do
      let(:file_input) { [
        ".1...",
        "...*.",
        "69...",
        "./...",
        "40.4%",
      ] }

      it "creates @engine_matric with schematic characters in an array of string arrays" do
        expect(schematic.engine_matrix).to eq([
          [".", "1", ".", ".", "."],
          [".", ".", ".", "*", "."],
          ["6", "9", ".", ".", "."],
          [".", "/", ".", ".", "."],
          ["4", "0", ".", "4", "%"],
        ])
      end
    end
  end

  describe "#slot_type" do
    let(:test_arg) { '.' }
    subject { schematic.slot_type(test_arg) }

    context "given a '.'" do
      let(:test_arg) { '.' }
      it "returns :blank" do
        expect(subject).to eq(:blank)
      end
    end

    context "given a numeric character" do
      context "given '8'" do
        let(:test_arg) { '8' }
        it "returns :number" do
          expect(subject).to eq(:number)
        end
      end

      context "given '0'" do
        let(:test_arg) { '0' }
        it "returns :number" do
          expect(subject).to eq(:number)
        end
      end
    end

    context "given an alphabet character" do
      context "given 'D'" do
        let(:test_arg) { 'D' }
        it "returns :symbol" do
          expect(subject).to eq(:symbol)
        end
      end

      context "given 't'" do
        let(:test_arg) { 't' }
        it "returns :symbol" do
          expect(subject).to eq(:symbol)
        end
      end
    end

    context "given various symbols" do
      context "given '$'" do
        let(:test_arg) { '$' }
        it "returns :symbol" do
          expect(subject).to eq(:symbol)
        end
      end

      context "given '^'" do
        let(:test_arg) { '^' }
        it "returns :symbol" do
          expect(subject).to eq(:symbol)
        end
      end

      context "given '/'" do
        let(:test_arg) { '/' }
        it "returns :symbol" do
          expect(subject).to eq(:symbol)
        end
      end

      context "given '%'" do
        let(:test_arg) { '%' }
        it "returns :symbol" do
          expect(subject).to eq(:symbol)
        end
      end
    end
  end
end
