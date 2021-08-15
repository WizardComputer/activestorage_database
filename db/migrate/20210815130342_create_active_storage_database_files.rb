# frozen_string_literal: true

class CreateActiveStorageDatabaseFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :active_storage_database_files do |t|
      t.string :key, null: false, index: { unique: true }
      t.binary :data, null: false
      t.datetime :created_at, null: false
    end
  end
end
