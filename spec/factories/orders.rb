FactoryBot.define do
  factory :order do
    status { "pending" }
    date { Date.yesterday }
  end
end
