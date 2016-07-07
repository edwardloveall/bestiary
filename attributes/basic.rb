class Attributes::Basic
  attr_reader :name, :cr, :xp,
              :alignment, :size, :type,
              :initiative, :senses, :perception,
              :aura

  def initialize(name:, cr:, xp:,
                 alignment:, size:, type:,
                 initiative:, senses: '', perception: '',
                 aura: '')
    @name = name
    @cr = cr
    @xp = xp
    @alignment = alignment
    @size = size
    @type = type
    @initiative = initiative
    @senses = senses
    @perception = perception
    @aura = aura
  end

  def attributes
    {
      name: name,
      cr: cr,
      xp: xp,
      alignment: alignment,
      size: size,
      type: type,
      initiative: initiative,
      senses: senses,
      perception: perception,
      aura: aura
    }
  end

  def keys_for_sql
    attributes.keys.join(', ')
  end

  def values
    attributes.values
  end

  def value_placeholders
    (1..values.length).map { |n| "$#{n}" }.join(', ')
  end

  def to_sql
    <<-SQL
      INSERT INTO basic_attrs
      (#{keys_for_sql})
      VALUES (#{value_placeholders})
      RETURNING id
    SQL
  end
end
