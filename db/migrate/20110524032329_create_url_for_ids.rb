class CreateUrlForIds < ActiveRecord::Migration
  def self.up
    create_table :url_for_ids do |t|
      t.string :id
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :url_for_ids
  end
end
