FactoryBot.define do
  factory :item, class: Item do
    association :merchant
    name { Faker::Name.name }
    description { Faker::TvShows::TheOffice.quote }
    unit_price { Faker::Number.within(range: 1..100_000) }
  end
end
