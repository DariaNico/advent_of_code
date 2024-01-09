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

      it "creates @raw_engine_matrix with schematic characters in an array of string arrays" do
        expect(schematic.raw_engine_matrix).to eq([
          [".", "1", ".", ".", "."],
          [".", ".", ".", "*", "."],
          ["6", "9", ".", ".", "."],
          [".", "/", ".", ".", "."],
          ["4", "0", ".", "4", "%"],
        ])
      end
    end
  end

  describe "#parse_engine_matrix!" do
    let(:file_input) { [
      ".1...",
      "...*.",
      "./...",
      "40.4%",
    ] }

    it "sets engine_matrix to a matrix of SchematicCells based off raw_engine_matrix" do
      schematic.parse_engine_matrix!
      engine_matrix = schematic.engine_matrix

      expect(engine_matrix.all? { |row| row.all? { |cell| cell.class == SchematicCell } }).
        to be_truthy

      expect(engine_matrix.map { |row| row.map { |cell| cell.value } }).
        to eq(schematic.raw_engine_matrix)
    end
  end

  describe "#populate_matrix_neighbors!" do
    context "given the engine_matrix is only blanks" do
      let(:file_input) { [
        "...",
        "...",
      ] }

      it "does not populate any SchematicCell's neighbors" do
        schematic.populate_matrix_neighbors!
        expect(schematic.engine_matrix.flatten.map(&:neighbors).compact).to be_empty
      end
    end

    context "given the engine_matrix contains numbers and symbols" do
      let(:file_input) { [
        "1...",
        "./..",
      ] }

      let(:cell_0_0) { schematic.create_cell(value: '1',
                                             coordinates: [0, 0]) }
      let(:cell_1_1) { schematic.create_cell(value: '/',
                                             coordinates: [1, 1]) }
      let(:cell_0_1) { schematic.create_cell(coordinates: [0, 1]) }
      let(:cell_0_2) { schematic.create_cell(coordinates: [0, 2]) }
      let(:cell_1_0) { schematic.create_cell(coordinates: [1, 0]) }
      let(:cell_1_2) { schematic.create_cell(coordinates: [1, 2]) }


      it "the number and symbol cell's neighbors" do
        expected_neighbors = [
          [cell_0_0, cell_0_1, cell_1_0, cell_1_1],
          [cell_0_0, cell_0_1, cell_0_2, cell_1_0, cell_1_1, cell_1_2]
        ].flatten

        schematic.populate_matrix_neighbors!
        matrix_neighbors = schematic.engine_matrix.flatten.
          map(&:neighbors).flatten.compact

        expect(matrix_neighbors.
               zip(expected_neighbors).
               all? { |a, b| a.similar_to?(b) }).to be_truthy
      end
    end
  end

  describe "#find_cell" do
    let(:file_input) { [
      ".1...",
      ".7.*.",
      "./...",
      "40.4%",
    ] }

    it "returns the schematic_cell at the coordinate given" do
      found_cell = schematic.find_cell([1,1])
      test_cell = SchematicCell.new(row: 1,
                                    column: 1,
                                    max_coordinate: [3, 4],
                                    value: '7')
      expect(test_cell.similar_to?(found_cell)).to be_truthy

    end
  end
end

describe SchematicCell do
  let(:row) { 0 }
  let(:column) { 0 }
  let(:value) { '.' }
  let(:max_coordinate) { [100, 100] }
  let(:schematic_cell) { SchematicCell.new(row: row,
                                           column: column,
                                           max_coordinate: max_coordinate,
                                           value: value) }
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

  describe "#coordinates" do
    let(:row) { 6 }
    let(:column) { 9 }

    it "returns its own corrdinates" do
      expect(subject.coordinates).to eq([6, 9])
    end
  end

  describe "#row_neighbor_coordinates" do
    context "matrix boundaries" do
      context "column boundaries" do
        context "column neighbor coordinates less than 0" do
          let(:row) { 0 }
          let(:column) { 0 }

          it "returns neighbors, with min coord violations not included" do
            expect(subject.row_neighbor_coordinates).to eq(
              [subject.coordinates, [0, 1]]
            )
          end

        context "column neighbor coordinates greater than max_coordinate" do
            let(:max_coordinate) { [5, 8] }
            let(:row) { 5 }
            let(:column) { 8 }

            it "returns neighbors, with max coord violations not included" do
              expect(subject.row_neighbor_coordinates).to eq(
                [[5, 7], subject.coordinates]
              )
            end
          end
        end
      end

      context "row boundaries" do
        context "row neighbor coordinates less than 0" do
          let(:row) { 0 }
          let(:column) { 0 }

          it "returns neighbors, with min coord violations not included" do
            expect(subject.row_neighbor_coordinates(-1)).to eq([])
          end

        context "column neighbor coordinates greater than max_coordinate" do
            let(:max_coordinate) { [5, 8] }
            let(:row) { 5 }
            let(:column) { 8 }

            it "returns neighbors, with max coord violations not included" do
              expect(subject.row_neighbor_coordinates(6)).to eq([])
            end
          end
        end
      end
    end

    context "given no neighbor_row arg" do
      let(:row) { 3 }
      let(:column) { 2 }

      it "returns an array of all the the cell's row's neighbors (itself included)" do
        expect(subject.row_neighbor_coordinates).to eq(
          [[3, 1], subject.coordinates, [3, 3]]
        )
      end
    end

    context "given a neighbor_row arg" do
      let(:row) { 3 }
      let(:column) { 2 }

      it "returns and array of possible row neigbors for that row" do
        expect(subject.row_neighbor_coordinates(20)).to eq(
          [[20, 1], [20, 2], [20, 3]]
        )
      end
    end
  end

  describe "#all_neighbor_coordinates" do
      let(:row) { 3 }
      let(:column) { 6 }

      it "returns an array of all possible neighbor coords (itself included)" do
        expect(subject.all_neighbor_coordinates).to eq([
          [2, 5], [2, 6], [2, 7],
          [3, 5], subject.coordinates, [3, 7],
          [4, 5], [4, 6], [4, 7],
        ])
      end

      context "matrix boundaries" do
        context "given neighbor coordinates contain values less than 0" do
          let(:row) { 0 }
          let(:column) { 0 }

          it "returns only valid neighbors" do
            expect(subject.all_neighbor_coordinates).to eq([
               subject.coordinates, [0, 1],
               [1, 0], [1, 1],
            ])
          end
        end

        context "given neighbor coordinates contain values greater than max_coordinates" do
          let(:max_coordinate) { [6, 9] }
          let(:row) { 6 }
          let(:column) { 9 }

          it "returns only valid neighbors" do
            expect(subject.all_neighbor_coordinates).to eq([
              [5, 8], [5, 9],
              [6, 8], subject.coordinates,
            ])
          end
        end
      end
  end
end
