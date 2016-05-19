json.set! :resources do
  json.array! @comments, partial: 'admin/comments/comment', as: :comment
end
json.set! :count, @count