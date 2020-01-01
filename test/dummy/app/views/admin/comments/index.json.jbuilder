# frozen_string_literal: true

json.resources do
  json.array! @comments, partial: 'admin/comments/comment', as: :comment
end
json.count @count
