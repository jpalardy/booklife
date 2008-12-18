class AddBookToEvent < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      t.integer :book_id
    end
  end

  def self.down
    change_table :events do |t|
      t.remove :book_id
    end
  end
end
