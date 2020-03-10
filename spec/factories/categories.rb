FactoryBot.define do
  factory :category do
    company
    sequence(:name) {|n| "name#{n}" }
  end
end
