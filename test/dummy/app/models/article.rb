class Article < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  belongs_to :user

  validates :title, presence: true
  validates :text, presence: true

  validate :vulgarity_level

  class << self
    def published; where.not published_at: nil end
  end

  def published?; published_at.present? end

  def publish
    return nil if published_at.present?
    self.published_at = Time.current
    save!
  end

  def destroy force = false
    return false if published? && !force
    super()
  end

  private

    def vulgarity_level
      vulgar_word = "fuck"
      if (title.present? && title =~ /#{vulgar_word}/i) || (text.present? && text =~ /#{vulgar_word}/i)
        errors.add :base, "Article contains strong language."
      end
    end
end
