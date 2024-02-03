class Board < ApplicationRecord
    validates :size, presence: true
end
