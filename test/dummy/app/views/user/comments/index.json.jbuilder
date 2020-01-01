# frozen_string_literal: true

json.resources do
  json.array! @comments, partial: 'user/comments/comment', as: :comment
end
json.count @count
