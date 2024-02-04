FactoryBot.define do
  factory :cell do
    board

    alive { true }
    x_position { rand(1..board.size) }
    y_position { rand(1..board.size) }
  end
end
