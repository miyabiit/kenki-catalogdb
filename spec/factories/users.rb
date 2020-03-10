FactoryBot.define do
  factory :staff, class: Staff do
    sequence(:login_name) {|n| "kenki#{n}"}
    sequence(:name) {|n| "name#{n}"}
    staff_role { 'write' }
    password { 'password01234' }
  end
end
