FactoryGirl.define do
  factory :user do
    password "12345678"
    email "user@wmu.se"
    admin false
    approved true
    given_name "Jimmy"
    surname "User"
    
  end
  
  factory :user_not_approved, class: User do
    password "12345678"
    email "mrnotapproved@crap.crap"
    given_name "Joey"
    surname "Jerkface"
    
  end

  # This will use the User class (Admin would have been guessed)
  factory :admin, class: User do
    password "12345678"
    email "admin@crap.crap"
    admin      true
    approved true
    given_name "Suzie"
    surname "Boss"
    
  end
end