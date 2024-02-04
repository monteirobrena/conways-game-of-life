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

    it "should set status as alive" do
      cell = build :cell, x_position: 5, y_position: 10
      board.cells = [cell]
      board.save

      cell.set_status

      expect(cell.alive).to eql(true)
    end

    it "should set status as not alive" do
      cell = build :cell, x_position: 50
      board.cells = [cell]
      board.save

      cell.set_status

      expect(cell.alive).to eql(false)
    end
  end
end

# if x > size || y > size
#  => dead

# 8,14

# 1,1 1,2 1,3 1,4 1,5 1,6 1,7 1,8 1,9 1,10
# 2,1 2,2 2,3 2,4 2,5 2,6 2,7 2,8 2,9 2,10
# 3,1 3,2 3,3 3,4 3,5 3,6 3,7 3,8 3,9 3,10
# 4,1 4,2 4,3 4,4 4,5 4,6 4,7 4,8 4,9 4,10
# 5,1 5,2 5,3 5,4 5,5 5,6 5,7 5,8 5,9 5,10
# 6,1 6,2 6,3 6,4 6,5 6,6 6,7 6,8 6,9 6,10
# 7,1 7,2 7,3 7,4 7,5 7,6 7,7 7,8 7,9 7,10
# 8,1 8,2 8,3 8,4 8,5 8,6 8,7 8,8 8,9 8,10
# 9,1 9,2 9,3 9,4 9,5 9,6 9,7 9,8 9,9 9,10
# 10,1 10,2 10,3 10,4 10,5 10,6 10,7 10,8 10,9 10,10