require 'active_record'

project_root = File.dirname(File.absolute_path(__FILE__))
require_relative 'abx_modules/connection'
require_relative 'bclconnect/connection'

Dir.glob(project_root + '/abx_modules/*') { |file| require file }
Dir.glob(project_root + '/bclconnect/*') { |file| require file }

# Declaration of DB namespaces
module Db
  module AbxModules; end
  module Bclconnect; end

  def self.connect
    # Connect the database adapters
    Db::Bclconnect::MysqlActiveRecord.establish_connection(
      adapter: 'mysql2',
      host: '127.0.0.1',
      username: 'root',
      database: 'bclconnect',
      port: 3307
    )

    Db::AbxModules::PgActiveRecord.establish_connection(
      adapter: 'postgresql',
      host: '127.0.0.1',
      username: 'postgres',
      database: 'abx_modules',
      password: 'postgres',
      port: 6432
    )
  end
end
