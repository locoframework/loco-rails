json.set! :resources do
  json.array! @comments, partial: 'user/comments/comment', as: :comment
end
json.set! :count, @count