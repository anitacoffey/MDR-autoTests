module Db
  module AbxModules
    class OrderMatch < PgActiveRecord
      self.table_name = 'order_match_transaction'
    end
  end
end
