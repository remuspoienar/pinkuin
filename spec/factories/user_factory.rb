FactoryGirl.define do
  factory :user do
    username { Faker::Internet.user_name(6) }
    email { Faker::Internet.email }
    password { Faker::Internet.password(6, 12) }

    before(:create) do |user|
      user.skip_confirmation!
    end
  end
end