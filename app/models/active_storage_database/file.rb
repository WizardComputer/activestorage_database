# frozen_string_literal: true

class ActiveStorageDatabase::File < ActiveRecord::Base
  validates :key, presence: true, allow_blank: false, uniqueness: { case_sensitive: false }
end
