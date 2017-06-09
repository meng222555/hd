FactoryGirl.define do
  factory :user do
    sequence(:email)       {|n| "user#{n}@example.com" }
    password               'password'
    password_confirmation  'password'
    sign_in_count           0
    created_at              Time.now
    updated_at              { Time.now }
    sequence(:first_name)   {|n| "Tom#{n}" }
    sequence(:last_name)    {|n| "Jerry#{n}" }
  end

  factory :confirmed_user, parent: :user do
    confirmation_token      'abc11223344556677xyz'
    confirmed_at            Time.now
    confirmation_sent_at    Time.now
  end
end
