FactoryBot.define do
  factory :board do
    size { rand(1..30) }
    attempts { rand(1..10) }
  end

  size = rand(1..30)
  attempts = rand(1..10)

  factory :board_hash, class:Hash do
    defaults = {
      size: size,
      attempts: attempts,
      cells: []
    }
    initialize_with{ defaults.merge(attributes) }
  end
end
