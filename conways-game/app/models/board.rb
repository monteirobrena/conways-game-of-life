class Board < ApplicationRecord
  has_many :cells

  validates :size, :attempts, presence: true

  accepts_nested_attributes_for :cells
end
