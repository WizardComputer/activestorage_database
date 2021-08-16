# frozen_string_literal: true

class Person < ApplicationRecord
  has_one_attached :avatar
end
