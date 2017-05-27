class AddUpdTriggerToListings < ActiveRecord::Migration[5.0]
  def up
    execute "ALTER TABLE listings ADD COLUMN searchtext TSVECTOR DEFAULT '';"
    execute "CREATE INDEX searchtext_gin ON listings USING GIN(searchtext);"

    execute "CREATE OR REPLACE FUNCTION f_upd_listings()
             RETURNS TRIGGER AS
             $$
             DECLARE
               property_type_string character varying;
               subtype_string character varying;
               district_string character varying;
               estate_string character varying;
               tenure_string character varying;
             BEGIN
               -- set size_sqft, size_sqm to NULL if either size_unit or size_area NULL
               -- else determine both size_sqft, size_sqm
               IF ( NEW.size_unit IS NULL) OR ( NEW.size_area IS NULL) THEN

                 IF ( NEW.size_sqm IS NOT NULL) THEN
                   NEW.size_sqm := NULL;
                 END IF;
                 IF ( NEW.size_sqft IS NOT NULL) THEN
                   NEW.size_sqft := NULL;
                 END IF;

               ELSE 

                 IF ( NEW.size_area = 0) THEN
                   NEW.size_sqm := 0;
                   NEW.size_sqft := 0;
                 ELSE
                   
                   IF ( NEW.size_unit = 'SQM') THEN
                     NEW.size_sqm := NEW.size_area;
                     NEW.size_sqft := NEW.size_area / 0.092903;
                   ELSE
                     NEW.size_sqft := NEW.size_area;
                     NEW.size_sqm := NEW.size_area * 0.092903;
                   END IF;
                   
                 END IF;
                
               END IF; -- size_unit end

               -- update searchtext col if search terms changed
                IF ( NEW.listing_type <> OLD.listing_type) 
                OR ( NEW.property_type_id <> OLD.property_type_id) 
                OR ( NEW.property_sub_type_id <> OLD.property_sub_type_id) 
                OR ( NEW.district_id <> OLD.district_id) 
                OR ( NEW.estate_id <> OLD.estate_id) 
                OR ( NEW.tenure_id <> OLD.tenure_id) 
                OR ( NEW.floor <> OLD.floor) 
                OR ( NEW.furnishing <> OLD.furnishing) 
                OR ( NEW.address <> OLD.address) 
                OR ( NEW.postal_code <> OLD.postal_code) 
                OR ( NEW.listing_name <> OLD.listing_name) 
                OR ( NEW.description <> OLD.description) THEN
                
                  SELECT lower( property_types.description) into property_type_string FROM property_types where id = NEW.property_type_id;
                  SELECT lower( property_sub_types.description) into subtype_string FROM property_sub_types where id = NEW.property_sub_type_id;
                  SELECT lower( districts.description) into district_string FROM districts where id = NEW.district_id;
                  SELECT lower( estates.description) into estate_string FROM estates where id = NEW.estate_id;
                  SELECT lower( tenures.description) into tenure_string FROM tenures where id = NEW.tenure_id;
                  
                  property_type_string := COALESCE( property_type_string, '');
                  subtype_string := COALESCE( subtype_string, '');
                  district_string := COALESCE( district_string, '');
                  estate_string := COALESCE( estate_string, '');
                  tenure_string := COALESCE( tenure_string, '');
                  
               -- NEW.searchtext := to_tsvector('pg_catalog.simple', -- 'english' works better
                  NEW.searchtext := to_tsvector('english', 
                                                 NEW.listing_type || ' ' || 
                                                 property_type_string || ' ' || 
                                                 subtype_string || ' ' || 
                                                 district_string || ' ' || 
                                                 estate_string || ' ' || 
                                                 tenure_string || ' ' || 
                                                 NEW.floor || ' ' || 
                                                 NEW.furnishing || ' ' || 
                                                 NEW.address || ' ' || 
                                                 NEW.postal_code || ' ' || 
                                                 NEW.listing_name || ' ' || 
                                                 NEW.description);
                END IF; -- searchtext end

               RETURN NEW;
             END;
             $$
             LANGUAGE plpgsql;"

    execute "DROP TRIGGER IF EXISTS t_upd_listings ON listings RESTRICT;"

    execute "CREATE TRIGGER t_upd_listings BEFORE UPDATE ON listings FOR EACH ROW EXECUTE PROCEDURE f_upd_listings();"

  end

  def down
    execute "DROP TRIGGER IF EXISTS t_upd_listings ON listings RESTRICT;"
    execute "DROP FUNCTION IF EXISTS f_upd_listings();"

    execute "DROP INDEX IF EXISTS searchtext_gin;"
    execute "ALTER TABLE listings DROP COLUMN IF EXISTS searchtext;"
  end
end
