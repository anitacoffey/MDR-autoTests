module Db
  module Bclconnect
    class AccountUser < MysqlActiveRecord
      self.table_name = 'account_users'
      belongs_to :account, foreign_key: 'accountid'
    end
  end
end
