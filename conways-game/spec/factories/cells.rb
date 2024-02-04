FactoryBot.define do
  factory :cell do
    association :board, factory: :board

    alive { true }
    x_position { rand(1..board.size) }
    y_position { rand(1..board.size) }
  end

  factory :cell_hash, class:Hash do
    defaults = {
      alive: true,
      x_position: 10,
      y_position: 20
    }
    initialize_with{ defaults.merge(attributes) }
  end
end
