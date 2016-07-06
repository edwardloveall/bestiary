require 'bundler/setup'
require 'nokogiri'
require 'pg'
require 'net/http'
require 'pry'

uri = URI('http://paizo.com/pathfinderRPG/prd/bestiary3/baykok.html')
response = Net::HTTP.get(uri)
parsed = Nokogiri::HTML(response)

title_group = parsed.at('.stat-block-title')

title = title_group.children.first.text.strip
cr = title_group.at('.stat-block-cr').text.gsub(/(CR )/, '').to_i
xp = parsed.at('.stat-block-xp').text.gsub(/(XP |,)/, '').to_i
attrs = [title, cr, xp]

db = PG.connect(dbname: 'bestiary')
sql = <<-SQL
  INSERT INTO monsters
  (title, cr, xp)
  VALUES ($1, $2, $3)
SQL
db.exec_params(sql, attrs)
