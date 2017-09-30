FactoryGirl.define do
  factory :project do
    name { "#{FFaker::Lorem.word}-#{SecureRandom.hex(4)}" }
    user
  end
end
