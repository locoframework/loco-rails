# frozen_string_literal: true

class Comment
  module Create
    def self.call(payload)
      comment = Comment.new(payload[:comment])
      return Result[ok: false, val: { comment: }] unless comment.save

      Loco.emit({ article_id: comment.article_id, event: :created,
                  comments_count: comment.article.comments.count }, subject: comment)
      Result[ok: true, val: { comment: }]
    end
  end
end
