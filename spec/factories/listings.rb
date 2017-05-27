FactoryGirl.define do

  factory :listing do
    listing_type 'FOR SALE'
    user_id 1

    rental_type {
      if listing_type == 'FOR RENT'
        ['Whole Unit', 'Room Only'].shuffle[0]
      end
    }

    sequence(:property_type_id, (1..3).cycle) { |n| n } # 1 'HDB', 2 'Condominium/Apartment', 3 'Landed Property'

    property_sub_type_id {
      if property_type_id == 1
        (17..29).to_a.shuffle[0]
      elsif property_type_id == 2
        (1..5).to_a.shuffle[0]
      elsif property_type_id == 3
        (6..16).to_a.shuffle[0]
      end
    }

    tenure_id {
      if listing_type == 'FOR SALE'
        if property_type_id == 1
          2
        elsif property_type_id == 2
          (1..2).to_a.shuffle[0]
        elsif property_type_id == 3
          (1..2).to_a.shuffle[0]
        end
      end
    }

    district_id {
      unless property_type_id == 1
        (1..28).to_a.shuffle[0]
      end
    }

    estate_id {
      if property_type_id == 1
        (1..27).to_a.shuffle[0]
      end
    }

    address {
      Faker::Address.street_address
    }

    postal_code {
      Faker::Address.postcode
    }

   show_unit {
      [0,1].shuffle[0] # 0 false
    }

   floor {
      [ nil,0,1,2,4,5,6,7,8,9,10,11,12,13,14,15,16].shuffle[0]
    }

   unit_no {
      "#{floor}-#{Faker::Address.building_number}"
    }

    size {
      ( (93..5432).to_a << nil).shuffle[0]
    }

    uom {
      if property_type_id == 1
        'sqm'
      elsif property_type_id == 2 or property_type_id == 3
        'sqft'
      end
    }

    bedrooms {
      ( (1..10).to_a << nil).shuffle[0]
    }

    bathrooms {
      ( (1..10).to_a << nil).shuffle[0]
    }

    furnishing {
      [ nil, 'Unfurnished', 'Partially Furnished', 'Fully Furnished'].shuffle[0]
    }

    floor_type {
      [ nil, 'Ground', 'Low', 'Middle', 'High', 'Penthouse'].shuffle[0]
    }

    description {
      [ nil, Faker::University.name].shuffle[0]
    }

    listing_name {
      [ nil, Faker::Space.star].shuffle[0]
    }

    asking_price {
      [ nil, "#{Faker::Address.building_number}00"].shuffle[0]
    }

  end
end
