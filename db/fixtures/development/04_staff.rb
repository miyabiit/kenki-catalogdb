# coding: utf-8

if user = Staff.find_or_initialize_by(login_name: 'staff')
  user.company = Company.find_by(name: 'テスト建機1')
  user.password = 'kenki012'
  user.save!
end
