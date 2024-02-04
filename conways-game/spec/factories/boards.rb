FactoryBot.define do
  factory :board do
    size { rand(1..30) }
    attempts { rand(1..10) }
  end

  factory :board_hash, class:Hash do
    defaults = {
      size: 30,
      attempts: 10,
      cells: []
    }
    initialize_with{ defaults.merge(attributes) }
  end
end
