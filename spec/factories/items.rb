# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    uri "MyURI"
    item_type "MyFormat"
  end
end
