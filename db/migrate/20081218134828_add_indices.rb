class AddIndices < ActiveRecord::Migration
  def self.up
    change_table :books do |t|
      t.index :isbn
    end

    change_table :users do |t|
      t.index :openid
      t.index :username
    end

    change_table :ownerships do |t|
      t.index [   :isbn, :user_id]
      t.index [ :status, :user_id]
      t.index [:book_id, :user_id]
    end
  end

  def self.down
    change_table :books do |t|
      t.remove_index :isbn
    end

    change_table :users do |t|
      t.remove_index :openid
      t.remove_index :username
    end

    change_table :ownerships do |t|
      t.remove_index [   :isbn, :user_id]
      t.remove_index [ :status, :user_id]
      t.remove_index [:book_id, :user_id]
    end
  end
end
