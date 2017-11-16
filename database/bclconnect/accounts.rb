module Db
  module Bclconnect
    class Account < MysqlActiveRecord
      self.table_name = 'account'
    end
  end
end
