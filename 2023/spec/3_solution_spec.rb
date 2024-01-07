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

end

describe SchematicCell do
  let(:row) { 0 }
  let(:column) { 0 }
  let(:value) { '.' }
  let(:schematic_cell) { SchematicCell.new(row: row, column: column, value: value) }
  subject { schematic_cell }

  describe "#determine_cell_type!" do
    let(:value) { '.' }

    context "given a '.' value" do
      let(:value) { '.' }
      it "sets @cell_type to :blank" do
        subject.determine_cell_type!
        expect(subject.cell_type).to eq(:blank)
      end
    end

    context "given a numeric character" do
      context "given '8' value" do
        let(:value) { '8' }
        it "sets @cell_type to :number" do
          subject.determine_cell_type!
          expect(subject.cell_type).to eq(:number)
        end
      end

      context "given '0' value" do
        let(:value) { '0' }
        it "sets @cell_type to :number" do
          subject.determine_cell_type!
          expect(subject.cell_type).to eq(:number)
        end
      end
    end

    context "given an alphabet character" do
      context "given 'D' value" do
        let(:value) { 'D' }
        it "sets @cell_type to :symbol" do
          subject.determine_cell_type!
          expect(subject.cell_type).to eq(:symbol)
        end
      end

      context "given 't' value" do
        let(:value) { 't' }
        it "sets @cell_type to :symbol" do
          subject.determine_cell_type!
          expect(subject.cell_type).to eq(:symbol)
        end
      end
    end

    context "given various symbols" do
      context "given '$' value" do
        let(:value) { '$' }
        it "sets @cell_type to :symbol" do
          subject.determine_cell_type!
          expect(subject.cell_type).to eq(:symbol)
        end
      end

      context "given '^' value" do
        let(:value) { '^' }
        it "sets @cell_type to :symbol" do
          subject.determine_cell_type!
          expect(subject.cell_type).to eq(:symbol)
        end
      end

      context "given '/' value" do
        let(:value) { '/' }
        it "sets @cell_type to :symbol" do
          subject.determine_cell_type!
          expect(subject.cell_type).to eq(:symbol)
        end
      end

      context "given '%' value" do
        let(:value) { '%' }
        it "sets @cell_type to :symbol" do
          subject.determine_cell_type!
          expect(subject.cell_type).to eq(:symbol)
        end
      end
    end

  end
end
