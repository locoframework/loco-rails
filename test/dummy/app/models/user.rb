# frozen_string_literal: true

class User < ApplicationRecord
  has_many :articles

  has_secure_password

  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :username, presence: true, uniqueness: { case_sensitive: false },
                       format: { with: /\A[a-z][a-z0-9_\-]*\z/i }
  validates :password_confirmation, presence: { on: :create }

  def confirmed=(val)
    success = val == case val.class.name
                     when 'String' then '1'
                     when 'Fixnum' then 1
                     else true
                     end
    self.confirmed_at = success ? Time.current : nil
  end

  def confirmed
    !confirmed_at.nil?
  end

  def confirmed?
    confirmed
  end
end
