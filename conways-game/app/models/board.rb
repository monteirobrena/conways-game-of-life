class Board < ApplicationRecord
    validates :size, :attempts, presence: true
end
