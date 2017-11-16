require 'active_record'
require 'require_all'

# Declaration of DB namespaces
module Db
  module AbxModules; end
  module Bclconnect; end
end

# Load the model files
require_all 'abx_modules'
require_all 'bclconnect'

# Connect the database adapters
MysqlActiveRecord.establish_connection(
  adapter: 'mysql2',
  host: '127.0.0.1',
  username: 'root',
  database: 'bclconnect',
  port: 3307
)

PgActiveRecord.establish_connection(
  adapter: 'postgresql',
  host: '127.0.0.1',
  username: 'postgres',
  database: 'abx_modules',
  password: 'postgres',
  port: 6432
)
