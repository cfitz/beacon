# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :topic do
    name "MyTopic"
    documents [ FactoryGirl.create(:document), FactoryGirl.create(:document) ]
  end
end
