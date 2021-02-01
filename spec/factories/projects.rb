FactoryBot.define do
  factory :project do
    name { "#{FFaker::Lorem.word}-#{SecureRandom.hex(4)}" }
    user

    trait :factory_project do
      id { 100 }
      name { 'factory project' }
    end
  end
end
