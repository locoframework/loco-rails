class Room < ApplicationRecord
  validates :name, presence: true
end
