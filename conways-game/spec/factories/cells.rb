FactoryBot.define do
  factory :cell do
    association :board, factory: :board

    alive { true }
    x_position { rand(1..board.size) }
    y_position { rand(1..board.size) }
  end

  x_position = rand(1..30)
  y_position = rand(1..30)

  factory :cell_hash, class:Hash do

    defaults = {
      alive: true,
      x_position: x_position,
      y_position: y_position
    }
    initialize_with{ defaults.merge(attributes) }
  end
end
