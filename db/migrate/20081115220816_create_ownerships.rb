class CreateOwnerships < ActiveRecord::Migration
  def self.up
    create_table :ownerships do |t|
      t.references :user, :book
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :ownerships
  end
end
