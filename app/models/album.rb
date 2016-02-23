class Album < ActiveRecord::Base
  serialize :photo_ids

  def count
    return photos.count
  end

  def photos

    if not self.start.blank?
      date_start = self.start.to_datetime
      p_start = get_predicate('date_taken', date_start, :gteq)
      exp = p_start
    end

    if not self.end.blank?
      date_end = self.end.to_time + 25.hours - 1.seconds
      p_end = get_predicate('date_taken', date_end, :lteq)
      if not exp.blank?
        exp = exp&p_end
      else
        exp= p_end
      end
    end

    if not self.make.blank?
      p_make = get_predicate('make', self.make, :eq)
      if not exp.blank?
        exp = exp&p_make
      else
        exp = p_make
      end
    end

    if not self.model.blank?
      p_model = get_predicate('model', self.model, :eq)
      if not exp.blank?
        exp = exp&p_model
      else
        exp = p_model
      end
    end

    location_stub = Squeel::Nodes::Stub.new(:location)

    if not self.country.blank?
      p_country = get_predicate(:country, self.country, :eq)
      k_country = Squeel::Nodes::KeyPath.new([location_stub, p_country])
      if not exp.blank?
        exp = exp&k_country
      else
        exp = k_country
      end
    end

    if not self.city.blank?
      p_city = get_predicate('city', self.city, :eq)
      k_city = Squeel::Nodes::KeyPath.new([location_stub, p_city])
      if not exp.blank?
        exp = exp&k_city
      else
        exp = k_city
      end
    end

    if not self.photo_ids.blank?
      p_photo_ids = get_predicate('id', self.photo_ids, :in)
      if not exp.blank?
        exp = exp|p_photo_ids
      else
        exp = p_photo_ids
      end
    end
    puts Photo.joins(:location).where(exp).to_sql
    Photo.joins(:location).where(exp)

  end

  def self.generate_year_based_albums
    distinct_years = Photo.pluck(:date_taken).map{|x| x.year}.uniq.each do |rec|
      album = Album.new
      album.name =  rec.to_s
      album.start = Date.new(rec.to_i, 1, 1)
      album.end = Date.new(rec.to_i, 12, 31)
      album.album_type = "year"
      album.save
    end
  end

  def self.generate_month_based_albums
    distinct_months = Photo.pluck(:date_taken).map{|x| Date.new(x.year, x.month, 1)}.uniq.each do |rec|
      album = Album.new
      album.name = rec.strftime("%b %Y").to_s
      album.start = rec
      album.end = (rec >> 1) -1
      album.album_type = "month"
      album.save
    end
  end

  def self.generate_inteval_based_albums(inteval=10, density=10)
    inteval = inteval*60
    albums=[]

    Photo.all.order(:date_taken).each do |photo|

      flag ||= false
      albums.each do |serie|
        if photo.date_taken < (serie.max + inteval) and photo.date_taken > (serie.min - inteval)
          serie.push  photo.date_taken
          flag ||= true
        end
      end

      albums.push [photo.date_taken] unless flag
    end


    albums.delete_if do |album|

      if album.count < density
        true
      else
        new_album = self.new
        new_album.name = album.min.strftime("%b %Y %d").to_s
        new_album.start = album.min
        new_album.end = album.max
        new_album.album_type = "event"
        new_album.save
        false
      end
    end

    return albums
  end

  private

  def get_predicate(col, value, predicate)
    Squeel::Nodes::Predicate.new(Squeel::Nodes::Stub.new(col), predicate, value)
  end
end
