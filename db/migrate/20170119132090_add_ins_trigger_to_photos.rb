class AddInsTriggerToPhotos < ActiveRecord::Migration[5.0]
  def up
    execute "CREATE OR REPLACE FUNCTION f_ins_photos()
      -- implemented at db trigger coz app can't handle race condition
      -- aim, set seq of created photo rec to 1 plus max( seq) of existing photo recs belonging to listing_id.
             RETURNS TRIGGER AS
             $$
             DECLARE
               max_seq integer;
             BEGIN
               NEW.created_at := now();
               NEW.updated_at := NEW.created_at;
               
               SELECT max( seq) INTO max_seq FROM photos WHERE listing_id = NEW.listing_id;
               
               IF ( max_seq IS NULL) THEN
                 NEW.seq := 1;
               ELSE 
                 NEW.seq := max_seq + 1;
               END IF;
               RETURN NEW;
             END;
             $$
             LANGUAGE plpgsql;"

    execute "DROP TRIGGER IF EXISTS t_ins_photos ON photos RESTRICT;"

    execute "CREATE TRIGGER t_ins_photos BEFORE INSERT ON photos FOR EACH ROW EXECUTE PROCEDURE f_ins_photos();"

  end

  def down
  end
end
