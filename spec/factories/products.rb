FactoryBot.define do
  factory :product do
    sequence(:product_code) {|n| "code#{n}" }
    sequence(:product_name) {|n| "product#{n}" }
    sequence(:title) {|n| "title#{n}" }
  end
end
