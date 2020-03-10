FactoryBot.define do
  factory :stock_product do
    product
    company
    category
    sequence(:spec) {|n| "spec#{n}" }
  end
end
