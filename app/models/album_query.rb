class AlbumQuery
  attr_reader :relation

  def initialize()
    @relation = context
  end


  def kl
    @relation.where(country.or(make))
  end

  def to_sql
    kl.to_sql
  end



  def country(country)
    location_table[:country].eq("Australia")
  end

  def make(make)
    photo_table[:make].eq("LG")
  end
  private
  def context
    photo_table.project(Arel.star).join(location_table).on(photo_table[:location_id].eq(location_table[:id]))
  end

  def photo_table
    Arel::Table.new(:photos)
  end

  def location_table
    Arel::Table.new(:locations)
  end



end
