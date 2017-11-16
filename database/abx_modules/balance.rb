module Db
  module AbxModules
    class Balance < PgActiveRecord
      self.table_name = 'balance'
    end
  end
end
