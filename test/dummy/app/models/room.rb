# frozen_string_literal: true

class Room < ApplicationRecord
  validates :name, presence: true

  has_many :messages, dependent: :destroy
end
