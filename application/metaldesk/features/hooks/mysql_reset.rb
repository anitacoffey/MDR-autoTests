class MysqlReset
  def self.reset_all_users_to_australia
    records = UserUiData.where(key: 'system')
    records.update_all(data: 'AUSTRALIA')
  end
end
