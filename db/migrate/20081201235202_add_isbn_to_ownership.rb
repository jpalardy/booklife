class AddIsbnToOwnership < ActiveRecord::Migration
  def self.up
    change_table :ownerships do |t|
      t.string :isbn
    end
    ownerships = Ownership.find(:all, :include => :book)

    ownerships.each do |ownership|
      ownership.isbn = ownership.book.isbn
      ownership.save
    end
  end

  def self.down
    remove_column :ownerships, :isbn
  end
end
