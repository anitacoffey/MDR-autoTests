module Db
  module AbxModules
    class FeeTransaction < PgActiveRecord
      self.table_name = 'fee_transaction'
    end
  end
end
