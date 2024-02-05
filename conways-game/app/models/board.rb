class Board < ApplicationRecord
  has_many :cells

  validates :size, :attempts, presence: true

  accepts_nested_attributes_for :cells

  after_create -> { set_cell_status }

  def set_cell_status
    cells.each do |cell|
      cell.set_status
    end
  end

  def set_next_state
    increment!(:attempts_performed)
    set_cell_status
  end

  def check_if_have_attempts
    attempts > attempts_performed
  end
end
