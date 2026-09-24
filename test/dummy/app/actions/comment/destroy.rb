# frozen_string_literal: true

class Comment
  module Destroy
    def self.call(payload, opts)
      user = opts.dig(:ars, :user) || (User.find(payload[:user_id]) if payload[:user_id])
      res = Find.(payload.slice(:article_id, :id).merge(user:))
      article, comment = res.val.values_at(:article, :comment)
      comment.destroy
      Loco.emit({ event: :destroyed, article_id: article.id,
                  comments_count: article.comments.count }, subject: comment)
      res
    end
  end
end
