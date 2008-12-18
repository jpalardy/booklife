require 'test_helper'

class BookTest < Test::Unit::TestCase
  context "A Book instance" do

    should_require_attributes :title, :authors, :isbn, :image_url, :published_on, :pages
    should_require_unique_attributes :isbn

    should_have_many :users
  end
end
