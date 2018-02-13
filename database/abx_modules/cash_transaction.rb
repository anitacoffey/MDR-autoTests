module Db
  module AbxModules
    class CashTransaction < PgActiveRecord
      self.table_name = 'cash_transaction'
    end
  end
end
