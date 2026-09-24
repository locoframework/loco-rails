# frozen_string_literal: true

class Comment
  module Update
    def self.call(payload, opts)
      user = opts.dig(:ars, :user) || (User.find(payload[:user_id]) if payload[:user_id])
      res = Find.(payload.slice(:article_id, :id).merge(user:))
      article, comment = res.val.values_at(:article, :comment)
      if comment.update(payload[:comment])
        Loco.emit({ event: :updated, article_id: article.id }, subject: comment)
        res
      else
        Result[ok: false, val: res.val]
      end
    end
  end
end
