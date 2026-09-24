# frozen_string_literal: true

class Article
  module Find
    def self.call(payload)
      skope = payload[:user] ? payload[:user].articles : Article
      skope = skope.published if payload[:published]
      Result[ok: true, val: { article: skope.includes(:user, :comments).find(payload[:id]) }]
    end
  end
end
