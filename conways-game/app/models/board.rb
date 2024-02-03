class Board < ApplicationRecord
    has_many :cells

    validates :size, :attempts, presence: true
end
