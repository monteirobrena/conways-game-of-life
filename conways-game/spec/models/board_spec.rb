require 'rails_helper'

describe Board do
  it { should have_many :cells }

  it { should validate_presence_of :size }
  it { should validate_presence_of :attempts }

  describe "creation with cells" do
    cells = 

    it "should build the board" do
      board = Board.new(
        size: 30,
        attempts: 10,
        cells: cells
      )

      expect(board).to be_valid
    end
  end
end