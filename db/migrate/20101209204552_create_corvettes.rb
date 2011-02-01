class CreateCorvettes < ActiveRecord::Migration
  def self.up
    create_table :corvettes do |t|
      t.string :body_style
      t.float :miles
      t.integer :year

      t.timestamps
    end
  end

  def self.down
    drop_table :corvettes
  end
end
