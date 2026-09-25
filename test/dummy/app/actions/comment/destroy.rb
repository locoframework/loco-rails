# frozen_string_literal: true

class Comment
  module Destroy
    def self.call(payload, opts)
      actor = opts.dig(:ars, :user) || opts.dig(:ars, :admin) || (User.find(payload[:user_id]) if payload[:user_id])
      val = Query.new(actor).comments.find(**payload.slice(:article_id, :id))
      article, comment = val.values_at(:article, :comment)
      comment.destroy
      Loco.emit({ event: :destroyed, article_id: article.id,
                  comments_count: article.comments.count }, subject: comment)
      Result[ok: true, val:]
    end
  end
end
