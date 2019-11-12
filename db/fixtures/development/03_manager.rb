# coding: utf-8

if user = Manager.find_or_initialize_by(login_name: 'manager')
  user.company = Company.find_by(name: 'テスト建機1')
  user.password = 'kenki012'
  user.save!
end
