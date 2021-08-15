# frozen_string_literal: true

require "test_helper"

class ActiveStorageDatabase::FileTest < ActiveSupport::TestCase
  setup do
    @image = active_storage_database_files(:image)
  end

  test "image is valid" do
    assert @image.valid?
  end

  test "#key must be unique" do
    new_file = ActiveStorageDatabase::File.new.tap do |file|
      file.key = @image.key
      file.data = "data"
    end

    assert_equal false, new_file.valid?
    assert_equal "has already been taken", new_file.errors[:key].first
  end
end
