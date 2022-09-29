FactoryBot.define do
  factory :car do
    name { Faker::Vehicle.make_and_model }
    price { 1000 }
    currency { "USD" }
  end
end
