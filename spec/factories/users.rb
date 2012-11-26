FactoryGirl.define do
  factory :user do
    password "12345678"
    email "user@crap.crap"
    admin false
    approved true
  end
  
  factory :user_not_approved, class: User do
    password "12345678"
    email "mrnotapproved@crap.crap"
  end

  # This will use the User class (Admin would have been guessed)
  factory :admin, class: User do
    password "12345678"
    email "admin@crap.crap"
    admin      true
    approved true
  end
end