# frozen_string_literal:

require "test_helper"

class ActiveStorage::Service::DatabaseServiceTest < ActiveSupport::TestCase
  setup do
    @service = ActiveStorage::Service.configure(:database, { database: { service: "Database" } })
    @file                       = activestorage_database_files(:image)
    @content_type               = "image/gif"
  end

  test "#upload, saves the file inside the database" do
    assert_kind_of ActivestorageDatabase::File, upload(io: @file.data)
    #assert_kind_of ActivestorageDatabase::File, upload(io: @file.data, checksum: Digest::MD5.base64digest(@file.data))
  end

  test "#upload, raises exception the invalid checksum" do
    assert_raise ActiveStorage::IntegrityError do
      upload(io: @file.data, checksum: Digest::MD5.base64digest("invalid"))
    end
  end

  test "#download, returns the content of the file if it exists, or raises on non-existing" do
    assert_equal @file.data, @service.download(@file.key)
    assert_raise ActiveStorage::FileNotFoundError do
      @service.download("invalid")
    end
  end

  test "#download, suports streaming when block is passed" do
    result = ""
    @service.download(@file.key) { |data| result += data }

    assert_equal @file.data, result
  end

  test "#download_chunk, returns chunk of the filed specified by the range" do
    range = (1..5)
    file_chunk = @service.download_chunk(@file.key, range)
    assert_equal @file.data[range], file_chunk
  end

  test "#delete, deletes the file" do
    expected_count = ActivestorageDatabase::File.count - 1
    @service.delete(@file.key)
    assert_equal expected_count, ActivestorageDatabase::File.count
  end

  test "#delete_prefixed, deletes all the filex with matching prefix" do
    expected_count = ActivestorageDatabase::File.count - 1
    @service.delete_prefixed(@file.key[0..10])
    assert_equal expected_count, ActivestorageDatabase::File.count
  end

  test "#exist?, returns true or false depending on the file key existance" do
    assert_equal true, @service.exist?(@file.key)
    assert_equal false, @service.exist?("invalid")
  end

  test "#url," do
    filename = ActiveStorage::Filename.new("avatar.png")
    url = @service.url(@file.key, expires_in: 5.minutes, disposition: :inline, filename: filename, content_type: "'image/png'")
    regex = URI.regexp

    assert url.include? "#{ActiveStorage::Current.url_options[:host]}/activestorage_database/files/"
    assert url =~ /\A#{URI::regexp}\z/
  end

  private
    def upload(key: SecureRandom.base58(24), io:, checksum: nil)
      @service.upload(key, StringIO.new(io), checksum: checksum)
    end
end
