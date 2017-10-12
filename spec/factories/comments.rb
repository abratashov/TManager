FactoryGirl.define do
  factory :comment do
    body { FFaker::Lorem.sentence(3) }
    attachment nil
    task

    trait :factory_comment do
      id 100
      body 'factory comment'
    end
  end
end
