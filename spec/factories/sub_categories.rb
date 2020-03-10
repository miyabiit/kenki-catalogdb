FactoryBot.define do
  factory :sub_category do
    company
    sequence(:name) {|n| "name#{n}" }
  end
end
