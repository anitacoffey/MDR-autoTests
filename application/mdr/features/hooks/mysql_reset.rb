class MysqlReset
  def self.reset_all_users_to_australia
    records = Db::Bclconnect::UserUiData.where(key: 'system')
    records.update_all(data: 'AUSTRALIA')
  end
end
