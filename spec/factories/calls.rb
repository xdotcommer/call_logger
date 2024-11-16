FactoryBot.define do
  factory :call do
    sequence(:incident_number) { |n| "INC#{n}" }
    call_type { "Assault" }
    call_type_group { "Violent Crime" }
    call_time { Time.current }
    call_origin { "Phone" }
    area { "Downtown" }
    area_name { "Central District" }
    latitude { 45.123456 }
    longitude { -122.654321 }
    hour { "10" }
    day_of_week { "Monday" }
    ward { 1 }
    district { "Central" }
    priority { "High" }
    month { "May" }
    year { 2023 }
    alcohol_related { true }
    mental_health { false }
    drug_related { false }
    dv_related { false }
    street { "123 Main St" }
  end
end