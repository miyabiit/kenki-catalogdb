# coding: utf-8

if user = Staff.find_or_initialize_by(login_name: 'staff1')
  user.company = Company.find_by(uid: 'TESTKENK')
  user.staff_role = 'write'
  user.password = 'kenki012'
  user.name = '入力ユーザー1'
  user.save!
end

if user = Staff.find_or_initialize_by(login_name: 'staff2')
  user.company = Company.find_by(uid: 'TESTKENK')
  user.staff_role = 'read'
  user.password = 'kenki012'
  user.name = '照会ユーザー1'
  user.save!
end
