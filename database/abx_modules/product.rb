module Db
  module AbxModules
    class Product < PgActiveRecord
      self.table_name = 'product'
    end
  end
end
