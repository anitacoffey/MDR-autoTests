module Db
  module AbxModules
    class Order < PgActiveRecord
      self.table_name = 'order'
    end
  end
end
