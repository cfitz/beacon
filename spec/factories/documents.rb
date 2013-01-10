# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :creator, :class => Person do
    name "John Creator"
    has_membership [ FactoryGirl.build(:corporate_body)]
  end
end


FactoryGirl.define do
  factory :document do
    title "My Document Title"
    date "2012-07-21"
    slug "My Document Slug"
    summary "My Document Summary"
  end
end
