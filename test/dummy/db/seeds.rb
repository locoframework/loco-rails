unless Admin.find_by(email: 'admin@example.com')
  Admin.create! email: 'admin@example.com', password: 'secret', password_confirmation: 'secret'
  puts 'Admin (admin@example.com) was added.'
end