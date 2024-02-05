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
end
