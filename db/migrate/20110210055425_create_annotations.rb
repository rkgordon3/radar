class CreateAnnotations < ActiveRecord::Migration
  def self.up
    create_table :annotations do |t|
      t.string :text
      t.integer :staff_id

      t.timestamps
    end
  end

  def self.down
    drop_table :annotations
  end
end
