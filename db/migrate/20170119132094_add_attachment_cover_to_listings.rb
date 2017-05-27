class AddAttachmentCoverToListings < ActiveRecord::Migration
  def self.up
    change_table :listings do |t|
      t.attachment :cover
    end
  end

  def self.down
    remove_attachment :listings, :cover
  end
end
