# frozen_string_literal: true

unless Admin::SupportMember.find_by(email: 'admin@example.com')
  Admin::SupportMember.create! email: 'admin@example.com', password: 'secret', password_confirmation: 'secret'
  puts 'Admin::SupportMember (admin@example.com) was added.'
end
