module Db
  module AbxModules
    class BalanceAdjustment < PgActiveRecord
      self.table_name = 'balance_adjustment'
    end
  end
end
