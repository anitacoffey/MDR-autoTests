module Db
  module AbxModules
    class BalanceHistory < PgActiveRecord
      self.table_name = 'balance_history'
    end
  end
end
