# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :person, :class => Person do
    name "John Smith"
    title "Sir"
  end
end
