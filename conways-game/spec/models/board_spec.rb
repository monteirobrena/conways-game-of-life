require 'rails_helper'

describe Board do
  it { should have_many :cells }

  it { should validate_presence_of :size }
  it { should validate_presence_of :attempts }

  it { should accept_nested_attributes_for(:cells) }

  describe "#set_cell_status" do
    it "triggers a callback after create" do
      board = build :board

      expect(board).to receive(:set_cell_status)

      board.save
    end
  end

  describe "creation with cells" do
    let(:board) { build :board }
    let(:cells) { create_list(:cell, 6) }

    it "should build the board" do
      board.cells = cells

      expect(board).to be_valid
      expect(board.cells.size).to eql(6)
    end

    it "should save the board" do
      board.cells = cells
      board.save

      expect(board.id).to_not be_nil
    end

    it "should save the cells" do
      board.cells = cells
      board.save

      expect(board.cells.first.id).to_not be_nil
      expect(board.cells.first.id).to eql(1)
      expect(board.cells.last.id).to_not be_nil
      expect(board.cells.last.id).to eql(6)
    end
  end
end