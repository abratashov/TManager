FactoryGirl.define do
  factory :task do
    name "MyString"
    deadline "2017-09-28 21:32:06"
    position 1
    done false
    project nil
    comments_count 1
  end
end
