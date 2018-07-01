FactoryBot.define do
  factory :user do
    username { "#{FFaker::Name.first_name}#{SecureRandom.hex(4)}" }
    password 'Pass0001'
    uid { "#{SecureRandom.hex}@m.cc" }
    email { "#{SecureRandom.hex}@m.cc" }
  end
end
