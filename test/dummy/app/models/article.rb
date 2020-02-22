# frozen_string_literal: true

class Article < ApplicationRecord
  CATEGORIES = ['Arts and Entertainment', 'Cars & Other Vehicles', 'Computers and Electronic',
                'Education and Communications', 'Family Life', 'Finance and Business',
                'Food and Entertaining', 'Health', 'Hobbies and Crafts',
                'Holidays and Traditions', 'Home and Garden', 'Pets and Animals',
                'Travel'].freeze

  has_many :comments, dependent: :destroy
  belongs_to :user

  attr_reader :published
  attr_accessor :admin_review_started_at

  validates :title, presence: true, length: { minimum: 3, maximum: 255 }
  validates :text, presence: true, length: { minimum: 100 }

  validate :vulgarity_level
  before_update :calculate_admin_review_time

  class << self
    def published(state = true)
      if state
        where.not published_at: nil
      else
        where published_at: nil
      end
    end
  end

  def published=(val)
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

  def published?
    published_at.present?
  end

  def publish
    set_published_at
    changed? ? save : nil
  end

  def destroy(force = false)
    return false if published? && !force

    super()
  end

  private

  def vulgarity_level
    return unless contains_vulgarity?(title) || contains_vulgarity?(text)

    errors.add :base, 'Article contains strong language.'
  end

  def contains_vulgarity?(attrib)
    vulgar_word = 'fuck'
    attrib.present? && attrib =~ /#{vulgar_word}/i
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
