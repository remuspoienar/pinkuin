FactoryGirl.define do
  factory :project do
    name { Faker::Company.name[0...32] }
    description { Faker::Lorem.paragraph(3) }
    status { Project::STATUS_ACTIVE }
    api_host { Faker::Internet.url }
    properties ({ a: 1, b: 2 })

    association :author, factory: :user
  end
end