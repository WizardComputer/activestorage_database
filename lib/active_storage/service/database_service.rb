# frozen_string_literal: true

module ActiveStorage
  class Service::DatabaseService < Service
    CHUNK_SIZE = 1.megabytes.freeze

    def upload(key, io, checksum: nil, **)
      instrument :upload, key: key, checksum: checksum do
        file = ActivestorageDatabase::File.create!(key: key, data: io.read)
        ensure_integrity_of(key, checksum) if checksum

        file
      end
    end

    def download(key, &block)
      if block_given?
        instrument :streaming_download, key: key do
          stream(key, &block)
        end
      else
        instrument :download, key: key do
          record = ActivestorageDatabase::File.find_by(key: key)
          record&.data || raise(ActiveStorage::FileNotFoundError)
        end
      end
    end

    def download_chunk(key, range)
      instrument :download_chunk, key: key, range: range do
        chunk_select = "SUBSTRING(data FROM #{range.begin + 1} FOR #{range.size}) AS chunk"
        ActivestorageDatabase::File.select(chunk_select).find_by(key: key)&.chunk || raise(ActiveStorage::FileNotFoundError)
      end
    end

    def delete(key)
      instrument :delete, key: key do
        ActivestorageDatabase::File.find_by(key: key)&.destroy
      end
    end

    def delete_prefixed(prefix)
      instrument :delete_prefixed, prefix: prefix do
        ActivestorageDatabase::File.where("key LIKE ?", "#{prefix}%").destroy_all
      end
    end

    def exist?(key)
      instrument :exist, key: key do |payload|
        answer = ActivestorageDatabase::File.where(key: key).exists?
        payload[:exist] = answer
        answer
      end
    end

    def url(key, expires_in:, filename:, disposition:, content_type:)
      instrument :url, key: key do |payload|
        content_disposition = content_disposition_with(type: disposition, filename: filename)
        verified_key_with_expiration = ActiveStorage.verifier.generate(
            {
                key: key,
                disposition: content_disposition,
                content_type: content_type
            },
            expires_in: expires_in,
            purpose: :blob_key
        )

        url_helpers.service_url(verified_key_with_expiration, filename: filename, **url_options)
      end
    end

    def url_for_direct_upload(key, expires_in:, content_type:, content_length:, checksum:)
      instrument :url, key: key do |payload|
        verified_token_with_expiration = ActiveStorage.verifier.generate(
            {
                key: key,
                content_type: content_type,
                content_length: content_length,
                checksum: checksum
            },
            expires_in: expires_in,
            purpose: :blob_token
        )

        url_helpers.update_service_url(verified_token_with_expiration, url_options) do |generated_url|
          payload[:url] = generated_url
        end
      end
    end

    def headers_for_direct_upload(_key, content_type:, **)
      { 'Content-Type' => content_type }
    end

    private
      def url_options
        ActiveStorage::Current.url_options
      end

      def ensure_integrity_of(key, checksum)
        file = ::ActivestorageDatabase::File.find_by(key: key)
        return if Digest::MD5.base64digest(file.data) == checksum

        delete(key)
        raise ActiveStorage::IntegrityError
      end

      def stream(key)
        size = ActivestorageDatabase::File.select('OCTET_LENGTH(data) AS size').find_by(key: key)&.size || raise(ActiveStorage::FileNotFoundError)

        (size / CHUNK_SIZE.to_f).ceil.times.each do |i|
          range = (i * CHUNK_SIZE..(i + 1) * CHUNK_SIZE - 1)
          yield download_chunk(key, range)
        end
      end

      def url_helpers
        @url_helpers ||= ActivestorageDatabase::Engine.routes.url_helpers
      end
  end
end
