# frozen_string_literal: true

class Comment
  module Destroy
    def self.call(payload, opts)
      res = Find.call(payload, opts)
      article, comment = res.val.values_at(:article, :comment)
      comment.destroy
      Loco.emit({ event: :destroyed, article_id: article.id,
                  comments_count: article.comments.count }, subject: comment)
      res
    end
  end
end
