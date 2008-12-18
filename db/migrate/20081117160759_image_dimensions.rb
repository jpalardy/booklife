class ImageDimensions < ActiveRecord::Migration
  def self.up
    change_table :books do |t|
      t.integer :image_width, :image_height
    end
  end

  def self.down
    remove_column :books, :image_width
    remove_column :books, :image_height
  end
end
