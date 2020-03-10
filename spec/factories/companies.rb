FactoryBot.define do
  factory :company do
    sequence(:uid) {|n| "uid#{n}" }
    sequence(:name) {|n| "name#{n}" }
  end
end
