module Db
  module AbxModules
    class Contract < PgActiveRecord
      self.table_name = 'contract'
    end
  end
end
