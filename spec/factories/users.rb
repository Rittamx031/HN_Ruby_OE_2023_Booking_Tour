FactoryBot.define do
  factory :user do
    username { "example_user" }
    sequence(:email) {|n| "user@example#{n}.com" }
    phone { "1234567890" }
    admin { false }
    password { 'password' }
    password_confirmation { 'password' }
    created_at { Time.now }
    updated_at { Time.now }
    confirmed_at { Time.now }

    factory :admin do
      admin {true}
      username{"administrator"}
    end

    factory :not_activated_user do
      confirmed_at { nil }
    end
  end
end
