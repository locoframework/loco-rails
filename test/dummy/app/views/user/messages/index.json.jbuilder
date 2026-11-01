# frozen_string_literal: true

json.resources @messages do |message|
  json.id message.id
  json.author message.user.username
  json.content message.content
end
