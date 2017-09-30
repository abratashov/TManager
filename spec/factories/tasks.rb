FactoryGirl.define do
  factory :task do
    name { "#{FFaker::Lorem.word}-#{SecureRandom.hex(4)}" }
    deadline "2017-09-28 21:32:06"
    position 1
    done false
    project
    comments_count 0
  end
end
