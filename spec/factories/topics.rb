# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :topic_with_documents, :class => Topic do
    name "MyTopic"
    documents [ FactoryGirl.create(:document), FactoryGirl.create(:document) ]
  end
end


FactoryGirl.define do
  factory :topic do
    name "MyTopic"
  end
end
