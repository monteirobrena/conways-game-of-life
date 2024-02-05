require 'rails_helper'

RSpec.describe Cell, type: :model do
  it { should belong_to :board }
  it { should belong_to(:main_cell).optional(:false) }

  it { should have_many(:neighbors).class_name('Cell') }
  it { should have_many(:neighbors).with_foreign_key('id') }

  it { should validate_presence_of :board }
  it { should validate_presence_of :alive }
  it { should validate_presence_of :x_position }
  it { should validate_presence_of :y_position }

  describe "#set_status" do
    let(:board) { build :board, size: 10 }

    it "should set status as alive if position is inside the board size" do
      cell = build :cell, x_position: 5, y_position: 10
      board.cells = [cell]
      board.save

      cell.set_status

      expect(cell.alive).to eql(true)
    end

    it "should set status as not alive if position is outside the board size" do
      cell = build :cell, x_position: 50
      board.cells = [cell]
      board.save

      cell.set_status

      expect(cell.alive).to eql(false)
    end
  end

  describe "#get_neighbors" do
    let(:board) { build :board, size: 10 }

    it "should get neighbors" do
      cell = build(:cell, x_position: 10, y_position: 10)
      neighbor_cell = build(:cell, x_position: 9, y_position: 10)
      board.cells = [cell, neighbor_cell]
      board.save

      expect(cell.get_neighbors).to_not be_empty
      expect(cell.get_neighbors.size).to eql(8)
      expect(cell.get_neighbors).to_not eql(Array.new(8))
    end

    it "should not get neighbors" do
      cell = build(:cell, x_position: 5, y_position: 5)
      neighbor_cell = build(:cell, x_position: 10, y_position: 10)
      board.cells = [cell, neighbor_cell]
      board.save

      expect(cell.get_neighbors).to_not be_empty
      expect(cell.get_neighbors.size).to eql(8)
      expect(cell.get_neighbors).to eql(Array.new(8))
    end
  end
end
