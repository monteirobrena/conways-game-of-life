class Cell < ApplicationRecord
  belongs_to :board

  validates :board, :alive, :x_position, :y_position, presence: true
end
