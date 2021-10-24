FactoryBot.define do
  factory :item, class: Item do
    association :merchant
    name { Faker::HitchhikersGuideToTheGalaxy.starship }
    description { Faker::MichaelScott.quote }
    unit_price { Faker::Number.within(range: 1..100_000) }
  end
end
