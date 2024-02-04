FactoryBot.define do
  factory :board do
    size { rand(1..30) }
    attempts { rand(1..10) }
  end
end
