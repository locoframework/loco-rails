json.resources do
  json.array! @comments, partial: 'main/comments/comment', as: :comment
end
json.count @count