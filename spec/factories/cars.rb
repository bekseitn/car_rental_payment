FactoryBot.define do
  factory :car do
    name { Faker::Vehicle.make_and_model }
    price_per_day { 1000 }
    currency { "USD" }
  end
end
