FactoryGirl.define do
  factory :comment do
    body { FFaker::Lorem.sentence(3) }
    attachment nil
    task
  end
end
