class Comment < ApplicationRecord
  belongs_to :article

  validates :author, presence: true
  validates :text, presence: true
  validates :article_id, presence: true

  after_initialize :set_defaults

  private

    def set_defaults
      self.emotion ||= 0
      self.pinned = false if pinned.nil?
      self.admin_rate ||= 3
    end
end
