# frozen_string_literal: true

json.resources @members do |member|
  json.id member.id
  json.username member.username
end
json.count @members.size
