# frozen_string_literal: true

json.resources @members do |member|
  json.id Ephemeron.used(member).id
  json.username member.username
end
json.count @members.size
