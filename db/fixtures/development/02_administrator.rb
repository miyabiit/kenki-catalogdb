# coding: utf-8

if user = Administrator.find_or_initialize_by(login_name: 'admin')
  user.password = 'kenki012'
  user.save!
end
