# frozen_string_literal: true

class Comment
  module Update
    def self.call(payload, opts)
      actor = opts.dig(:ars, :user) || opts.dig(:ars, :admin) || (User.find(payload[:user_id]) if payload[:user_id])
      val = Query.new(actor).comments.find(**payload.slice(:article_id, :id))
      article, comment = val.values_at(:article, :comment)
      ok = comment.update(payload[:comment])
      Loco.emit({ event: :updated, article_id: article.id }, subject: comment) if ok
      Result[ok:, val:]
    end
  end
end
