require 'test_helper'

class UserTest < Test::Unit::TestCase
  context "A User instance" do

    should_require_attributes        :username, :openid
    should_ensure_length_in_range    :username, 4..32
    should_allow_values_for          :username, "vegeta", "a233", "_aw_"
    should_not_allow_values_for      :username, "1234", "@*$@#"
    should_require_unique_attributes :username

    should_have_many :books
  end
end
