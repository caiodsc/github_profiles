# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    github_url { Faker::Internet.url(scheme: 'https', host: 'github.com', path: "/#{Faker::Internet.username(specifier: 6, separators: %w[_ -])}") }

    trait :with_github_details do
      github_name { Faker::Internet.username }
      followers { Faker::Number.number(digits: 3) }
      following { Faker::Number.number(digits: 2) }
      stars { Faker::Number.number(digits: 3) }
      contributions_last_year { Faker::Number.number(digits: 3) }
      profile_image_url { Faker::Avatar.image }
    end

    trait :processed do
      with_github_details
      state { :completed }
    end

    trait :processing do
      state { :processing }
    end

    trait :failed do
      state { :failed }
    end
  end
end
