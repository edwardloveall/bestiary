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
end
