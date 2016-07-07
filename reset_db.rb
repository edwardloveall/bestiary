require 'bundler/setup'
require 'pg'
include PG::Constants

db = PG.connect(dbname: 'bestiary')

tables = %w(monsters basic_attrs)
tables.each do |table_name|
  result = db.exec("DELETE FROM #{table_name}")

  if result.result_status == PGRES_COMMAND_OK
    puts "cleared table: #{table_name}"
  end
end
