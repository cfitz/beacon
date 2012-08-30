FactoryGirl.define do
  factory :user do
    password "crap"
    email "user@crap.crap"
    password "crapcrapcrap"
    admin false
    approved true
  end

  # This will use the User class (Admin would have been guessed)
  factory :admin, class: User do
    password "crapcrapcrap"
    email "admin@crap.crap"
    admin      true
    approved true
  end
end