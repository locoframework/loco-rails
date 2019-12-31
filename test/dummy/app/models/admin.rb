# frozen_string_literal: true

class Admin < ApplicationRecord
  has_secure_password

  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :password_confirmation, presence: { on: :create }
end
