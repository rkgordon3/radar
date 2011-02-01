class AddStateToCorvette < ActiveRecord::Migration
  def self.up
    add_column :corvettes, :state, :string
  end

  def self.down
    remove_column :corvettes, :state
  end
end
