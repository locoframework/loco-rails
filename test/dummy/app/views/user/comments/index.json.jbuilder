# frozen_string_literal: true

json.resources do
  json.array! Ephemeron.used(@comments), partial: 'user/comments/comment', as: :comment
end
json.count @count
