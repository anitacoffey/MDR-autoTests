module Db
  module AbxModules
    class TradeTransaction < PgActiveRecord
      self.table_name = 'trade_transaction'
    end
  end
end
