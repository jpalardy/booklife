class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.string :title, :authors, :isbn, :image_url, :published_on
      t.integer :pages

      t.timestamps
    end
  end

  def self.down
    drop_table :books
  end
end
