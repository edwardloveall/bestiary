class Bestiary::Attributes::Type
  attr_reader :title, :subtypes

  def initialize(title:, subtypes: [])
    @title = title
    @subtypes = subtypes
  end

  def ==(other)
    (title == other.title && subtypes == other.subtypes)
  end
end
