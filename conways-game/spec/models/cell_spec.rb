require 'rails_helper'

RSpec.describe Cell, type: :model do
  it { should belong_to :board }
  it { should belong_to(:main_cell).optional(:false) }

  it { should have_many(:neighbors).class_name('Cell') }
  it { should have_many(:neighbors).with_foreign_key('id') }

  it { should validate_presence_of :board }
  it { should validate_presence_of :x_position }
  it { should validate_presence_of :y_position }

  it { should validate_inclusion_of(:alive).in_array([true, false]) }

  describe "#set_status" do
    let(:board) { build :board, size: 10 }

    it "should call dies_when_outside_board after set_status" do
      cell = build :cell, x_position: 5, y_position: 5
      board.cells = [cell]
      board.save

      expect(cell).to receive(:set_status).and_call_original
      expect(cell).to receive(:dies_when_outside_board)
  
      cell.set_status
    end

    it "should call comes_alive after set_status" do
      board = create :board, size: 10
      cell = create :cell, board: board, x_position: 5, y_position: 5, alive: false

      board.cells = [
        cell,
        create(:cell, board: board, x_position: 4, y_position: 4, alive: true),
        create(:cell, board: board, x_position: 4, y_position: 5, alive: true),
        create(:cell, board: board, x_position: 4, y_position: 6, alive: true)
      ]

      expect(cell).to receive(:set_status).and_call_original
      expect(cell).to receive(:comes_alive)
  
      cell.set_status
    end

    it "should call dies_due_isolation after set_status" do
      board = create :board, size: 10
      cell = create :cell, board: board, x_position: 5, y_position: 5, alive: true

      board.cells = [
        cell,
        create(:cell, board: board, x_position: 4, y_position: 4, alive: true)
      ]

      expect(cell).to receive(:set_status).and_call_original
      expect(cell).to receive(:dies_due_isolation)
  
      cell.set_status
    end

    it "should call dies_due_overpopulation after set_status" do
      board = create :board, size: 10
      cell = create :cell, board: board, x_position: 5, y_position: 5, alive: true

      board.cells = [
        cell,
        create(:cell, board: board, x_position: 4, y_position: 4, alive: true),
        create(:cell, board: board, x_position: 4, y_position: 5, alive: true),
        create(:cell, board: board, x_position: 4, y_position: 6, alive: true),
        create(:cell, board: board, x_position: 5, y_position: 4, alive: true)
      ]

      expect(cell).to receive(:set_status).and_call_original
      expect(cell).to receive(:dies_due_overpopulation)
  
      cell.set_status
    end

    it "should call remains_alive after set_status" do
      board = create :board, size: 10
      cell = create :cell, board: board, x_position: 5, y_position: 5, alive: true

      board.cells = [
        cell,
        create(:cell, board: board, x_position: 4, y_position: 4, alive: true),
        create(:cell, board: board, x_position: 4, y_position: 5, alive: true)
      ]

      expect(cell).to receive(:set_status).and_call_original
      expect(cell).to receive(:remains_alive)
  
      cell.set_status
    end
  end

  describe "#dies_when_outside_board" do
    let(:board) { build :board, size: 10 }

    it "should set status as alive if position is inside the board size" do
      cell = create :cell, board: board, x_position: 5, y_position: 5
      board.cells = [cell]
      board.save

      cell.dies_when_outside_board

      expect(cell.alive).to eql(true)
    end

    it "should set status as not alive if position is outside the board size" do
      cell = build :cell, x_position: 50
      board.cells = [cell]
      board.save

      cell.dies_when_outside_board

      expect(cell.alive).to eql(false)
    end
  end

  describe "#comes_alive" do
    it "should comes alive if is dead and has 3 neighbors" do
      board = create :board, size: 10
      cell = create :cell, board: board, x_position: 5, y_position: 5, alive: false

      board.cells = [
        cell,
        create(:cell, board: board, x_position: 4, y_position: 4, alive: true),
        create(:cell, board: board, x_position: 4, y_position: 5, alive: true),
        create(:cell, board: board, x_position: 4, y_position: 6, alive: true)
      ]

      cell.comes_alive

      expect(cell.alive).to eql(true)
      expect(cell.created_at).to_not eql(cell.updated_at)
    end

    it "should not comes alive if is not dead" do
      board = create :board, size: 10
      cell = create :cell, board: board, x_position: 5, y_position: 5, alive: true

      board.cells = [
        cell,
        create(:cell, board: board, x_position: 4, y_position: 4, alive: true),
        create(:cell, board: board, x_position: 4, y_position: 5, alive: true),
        create(:cell, board: board, x_position: 4, y_position: 6, alive: true)
      ]

      cell.comes_alive

      expect(cell.alive).to eql(true)
      expect(cell.created_at).to eql(cell.updated_at)
    end
  end

  describe "#dies_due_isolation" do
    it "should dies if is alive and has less than 2 neighbors" do
      board = create :board, size: 10
      cell = create :cell, board: board, x_position: 5, y_position: 5, alive: true

      board.cells = [
        cell,
        create(:cell, board: board, x_position: 4, y_position: 4, alive: true)
      ]

      cell.dies_due_isolation

      expect(cell.alive).to eql(false)
      expect(cell.created_at).to_not eql(cell.updated_at)
    end

    it "should not dies if is already dead" do
      board = create :board, size: 10
      cell = create :cell, board: board, x_position: 5, y_position: 5, alive: false

      board.cells = [
        cell,
        create(:cell, board: board, x_position: 4, y_position: 4, alive: true)
      ]

      cell.dies_due_isolation

      expect(cell.alive).to eql(false)
      expect(cell.created_at).to eql(cell.updated_at)
    end
  end

  describe "#dies_due_overpopulation" do
    it "should dies if is alive and has more than 3 neighbors" do
      board = create :board, size: 10
      cell = create :cell, board: board, x_position: 5, y_position: 5, alive: true

      board.cells = [
        cell,
        create(:cell, board: board, x_position: 4, y_position: 4, alive: true),
        create(:cell, board: board, x_position: 4, y_position: 5, alive: true),
        create(:cell, board: board, x_position: 4, y_position: 6, alive: true),
        create(:cell, board: board, x_position: 5, y_position: 4, alive: true)
      ]

      cell.dies_due_overpopulation

      expect(cell.alive).to eql(false)
      expect(cell.created_at).to_not eql(cell.updated_at)
    end

    it "should not dies if is already dead" do
      board = create :board, size: 10
      cell = create :cell, board: board, x_position: 5, y_position: 5, alive: false

      board.cells = [
        cell,
        create(:cell, board: board, x_position: 4, y_position: 4, alive: true),
        create(:cell, board: board, x_position: 4, y_position: 5, alive: true),
        create(:cell, board: board, x_position: 4, y_position: 6, alive: true),
        create(:cell, board: board, x_position: 5, y_position: 4, alive: true)
      ]

      cell.dies_due_overpopulation

      expect(cell.alive).to eql(false)
      expect(cell.created_at).to eql(cell.updated_at)
    end
  end

  describe "#remains_alive" do
    it "should remains alive if is alive and has 2 neighbors" do
      board = create :board, size: 10
      cell = create :cell, board: board, x_position: 5, y_position: 5, alive: true

      board.cells = [
        cell,
        create(:cell, board: board, x_position: 4, y_position: 4, alive: true),
        create(:cell, board: board, x_position: 4, y_position: 5, alive: true)
      ]

      cell.remains_alive

      expect(cell.alive).to eql(true)
      expect(cell.created_at).to eql(cell.updated_at)
    end

    it "should remains alive if is alive and has 3 neighbors" do
      board = create :board, size: 10
      cell = create :cell, board: board, x_position: 5, y_position: 5, alive: true

      board.cells = [
        cell,
        create(:cell, board: board, x_position: 4, y_position: 4, alive: true),
        create(:cell, board: board, x_position: 4, y_position: 5, alive: true),
        create(:cell, board: board, x_position: 5, y_position: 4, alive: true)
      ]

      cell.remains_alive

      expect(cell.alive).to eql(true)
      expect(cell.created_at).to eql(cell.updated_at)
    end

    it "should not dies if is already dead" do
      board = create :board, size: 10
      cell = create :cell, board: board, x_position: 5, y_position: 5, alive: false

      board.cells = [
        cell,
        create(:cell, board: board, x_position: 4, y_position: 4, alive: true),
        create(:cell, board: board, x_position: 4, y_position: 5, alive: true)
      ]

      cell.remains_alive

      expect(cell.alive).to eql(false)
      expect(cell.created_at).to eql(cell.updated_at)
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

  describe "#count_neighbors" do
    let(:board) { build :board, size: 10 }

    it "should found count neighbors" do
      cell = build(:cell, x_position: 1, y_position: 1)
      neighbor_cell = build(:cell, x_position: 1, y_position: 2)
      board.cells = [cell, neighbor_cell]
      board.save

      expect(cell.count_neighbors).to_not be_nil
      expect(cell.count_neighbors).to eql(1)
    end

    it "should not found neighbors" do
      cell = build(:cell, x_position: 1, y_position: 1)
      board.cells = [cell]
      board.save

      expect(cell.count_neighbors).to_not be_nil
      expect(cell.count_neighbors).to eql(0)
    end
  end
end
