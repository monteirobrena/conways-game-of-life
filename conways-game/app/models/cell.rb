class Cell < ApplicationRecord
  belongs_to :board
  belongs_to :main_cell, class_name: 'Cell', optional: true

  has_many :neighbors, class_name: 'Cell', foreign_key: 'id'

  validates :board, :x_position, :y_position, presence: true

  validates :alive, inclusion: [true, false]

  def set_status
    return if dies_when_outside_board
    return if comes_alive
    return if dies_due_isolation
    return if dies_due_overpopulation
    return if remains_alive
  end

  def dies_when_outside_board
    if x_position > board.size || y_position > board.size
      self.update(alive: false) 
      true
    end
  end

  def comes_alive
    if !alive && count_neighbors == 3
      self.update(alive: true) 
      true
    end
  end

  def dies_due_isolation
    if alive && count_neighbors < 2
      self.update(alive: false) 
      true
    end
  end

  def dies_due_overpopulation
    if alive && count_neighbors > 3
      self.update(alive: false) 
      true
    end
  end

  def remains_alive
    if alive && (count_neighbors == 2 || count_neighbors == 3)
      self.update(alive: true) 
      true
    end
  end

  def get_neighbors
    cells_neighbors = []

    cells_neighbors << Cell.find_by(board: board, x_position: self.x_position, y_position: self.y_position - 1)
    cells_neighbors << Cell.find_by(board: board, x_position: self.x_position, y_position: self.y_position + 1)

    cells_neighbors << Cell.find_by(board: board, x_position: self.x_position - 1, y_position: self.y_position)
    cells_neighbors << Cell.find_by(board: board, x_position: self.x_position - 1, y_position: self.y_position - 1)
    cells_neighbors << Cell.find_by(board: board, x_position: self.x_position - 1, y_position: self.y_position + 1)

    cells_neighbors << Cell.find_by(board: board, x_position: self.x_position + 1, y_position: self.y_position)
    cells_neighbors << Cell.find_by(board: board, x_position: self.x_position + 1, y_position: self.y_position - 1)
    cells_neighbors << Cell.find_by(board: board, x_position: self.x_position + 1, y_position: self.y_position + 1)

    cells_neighbors
  end

  def count_neighbors
    get_neighbors.compact!.count
  end
end
