class Article < ActiveRecord::Base
  CATEGORIES = ["Arts and Entertainment", "Cars & Other Vehicles", "Computers and Electronic",
    "Education and Communications", "Family Life", "Finance and Business", "Food and Entertaining",
    "Health", "Hobbies and Crafts", "Holidays and Traditions", "Home and Garden", "Pets and Animals",
    "Travel"
  ]

  has_many :comments, dependent: :destroy
  belongs_to :user

  attr_reader :published
  attr_accessor :admin_review_started_at

  validates :title, presence: true
  validates :text, presence: true

  validate :vulgarity_level
  before_update :calculate_admin_review_time

  class << self
    def published state = true
      if state
        where.not published_at: nil
      else
        where published_at: nil
      end
    end
  end

  def published= val
    @published = case val.class.name
    when 'String' then val == '1'
    when 'NilClass' then nil
    else val ? true : false
    end
    if published
      set_published_at
    else
      self.published_at = nil
    end
  end

  def published?; published_at.present? end

  def publish
    set_published_at
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

    def set_published_at
      return nil if published_at.present?
      self.published_at = Time.current
    end

    def calculate_admin_review_time
      return if admin_review_started_at.nil?
      val = (Time.now.to_f * 1000 - admin_review_started_at.to_f) / 1000
      self.admin_review_time = val.round 2
    end
end
