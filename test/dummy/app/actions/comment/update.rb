# frozen_string_literal: true

class Comment
  module Update
    def self.call(payload, opts)
      user = opts.dig(:ars, :user) || (User.find(payload[:user_id]) if payload[:user_id])
      val = Query.new(user:).comments.find(**payload.slice(:article_id, :id))
      article, comment = val.values_at(:article, :comment)
      if comment.update(payload[:comment])
        Loco.emit({ event: :updated, article_id: article.id }, subject: comment)
        Result[ok: true, val:]
      else
        Result[ok: false, val:]
      end
    end
  end
end
