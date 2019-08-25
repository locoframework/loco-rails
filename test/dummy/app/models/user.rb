class User < ActiveRecord::Base
  has_many :articles

  has_secure_password

  validates :email, presence: true, uniqueness: { case_sensitive: false },
    format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
  validates :username, presence: true, uniqueness: { case_sensitive: false },
    format: {with: /\A[a-z][a-z0-9_\-]*\z/i}
  validates :password_confirmation, presence: {on: :create}

  def confirmed= val
    success = case val.class.name
    when "String" then val == '1'
    when "Fixnum" then val == 1
    else val == true
    end
    self.confirmed_at = success ? Time.current : nil
  end

  def confirmed; !!confirmed_at end
  def confirmed?; confirmed end
end
