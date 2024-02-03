class Cell < ApplicationRecord
  belongs_to :board
  belongs_to :main_cell, class_name: 'Cell', optional: true

  has_many :neighbors, class_name: 'Cell', foreign_key: 'id'

  validates :board, :alive, :x_position, :y_position, presence: true
end
