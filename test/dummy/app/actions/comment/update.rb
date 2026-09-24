# frozen_string_literal: true

class Comment
  module Update
    def self.call(payload, opts)
      res = Find.call(payload.slice(:user_id, :article_id, :id), opts)
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
