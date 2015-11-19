json.set! :resources do
  json.array! @users, partial: 'admin/users/user', as: :user
end
json.set! :count, @count