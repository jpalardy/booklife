require 'test_helper'

class OwnershipTest < ActiveSupport::TestCase
  context "A Ownership instance" do

    should_require_attributes :user, :book, :status, :isbn

    should_belong_to :user, :book

    should "only allow values in Status.all" do
      Status.all.each do |status|
        assert_good_value Ownership, :status, status
      end

      assert_bad_value Ownership, :status, 'bad', /is not included in the list/
      assert_bad_value Ownership, :status,   '-', /is not included in the list/
    end
  end
end
