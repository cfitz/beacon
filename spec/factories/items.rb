# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    url "http://beacon.io"
   # document {  FactoryGirl.create(:document) }
  end
end


FactoryGirl.define do
  factory :item_with_document, class: Item do
    url "http://beacon.io"
    document {  FactoryGirl.create(:document) }
  end
end
