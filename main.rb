$LOAD_PATH.unshift(Dir.pwd)
require 'bundler/setup'
require 'nokogiri'
require 'pg'
require 'net/http'
require 'attributes'
require 'monster'

# uri = URI('http://paizo.com/pathfinderRPG/prd/bestiary3/baykok.html')
# response = Net::HTTP.get(uri)
response = File.read('baykok.html')
parsed = Nokogiri::HTML(response)

title_group = parsed.at('.stat-block-title')

name = title_group.children.first.text.strip
cr = title_group.at('.stat-block-cr').text.gsub(/(CR )/, '').to_i

xp_ele = parsed.at('.stat-block-xp')
xp = xp_ele.text.gsub(/(XP |,)/, '').to_i

stat_block = xp_ele.next_element
alignment, size, type = stat_block.text.split(' ')

stat_block = stat_block.next_element
init_label = stat_block.css('b').select { |ele| ele.text == 'Init' }.first
senses_label = stat_block.css('b').select { |ele| ele.text == 'Senses' }.first
percept_label = stat_block.css('a').select do |ele|
  ele.text == 'Perception'
end.first
init = init_label.next_element.text.gsub(/[^\d|\-]/, '').to_i
senses = senses_label.next.text
perception = percept_label.next.text.gsub(/[^\d|\-]/, '').to_i

basic = Attributes::Basic.new(
  name: name,
  cr: cr,
  xp: xp,
  alignment: alignment,
  size: size,
  type: type,
  initiative: init,
  senses: senses,
  perception: perception
)

monster = Monster.new(basic: basic)

db = PG.connect(dbname: 'bestiary')

value_placeholders = (1..basic.attributes.values.count).map { |n| "$#{n}" }
sql = <<-SQL
  INSERT INTO basic_attrs
  (#{basic.attributes.keys.join(', ')})
  VALUES (#{value_placeholders.join(', ')})
  RETURNING id
SQL

result = db.exec_params(sql, basic.attributes.values)
basic_id = result.field_values('id').first

sql = <<-SQL
  INSERT INTO monsters
  (basic_attrs_id)
  VALUES (#{basic_id})
SQL

db.exec(sql)
result.field_values('id').first
