FactoryGirl.define do

  factory :listing do
    listing_type 'FOR SALE'
    user_id 123
    rental_type nil
    status 'FOR SALE'
  end

  factory :publishable_listing, parent: :listing do
    property_type_id      { PropertyType.pluck(:id).sample }
    property_sub_type_id  { PropertySubType.pluck(:id).sample }
    tenure_id             { Tenure.pluck(:id).sample }
    district_or_estate    { ['d', 'e'].sample }
    district_id {
      if district_or_estate == 'd'
        District.pluck(:id).sample
      end
    }
    estate_id {
      if district_or_estate == 'e'
        Estate.pluck(:id).sample
      end
    }

    address {
      Faker::Address.street_address
    }

    postal_code {
      Faker::Address.postcode
    }

    size_area {
      (93..5432).to_a.sample
    }

    size_unit {
      if district_or_estate == 'e'
        'SQM'
      else
        'SQFT'
      end
    }

    bedrooms             { Bedroom.pluck(:description).sample }
    bathrooms             { Bathroom.pluck(:description).sample }

    furnishing {
      [ 'Unfurnished', 'Partially Furnished', 'Fully Furnished'].sample
    }

    floor_type {
      [ 'Ground', 'Low', 'Middle', 'High', 'Penthouse'].sample
    }

    listing_name {
      Faker::Space.star
    }

    asking_price {
      "#{Faker::Address.building_number}00"
    }
  end

  factory :published_listing, parent: :publishable_listing do
    published  1
  end
end
