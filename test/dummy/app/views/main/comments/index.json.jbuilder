json.set! :resources do
  json.array! @comments, partial: 'main/comments/comment', as: :comment
end
json.set! :count, @count