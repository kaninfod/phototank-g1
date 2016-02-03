class Album < ActiveRecord::Base
  serialize :photo_ids
  
  def photos

    if not self.start.blank?
      p_start = get_predicate('date_taken', self.start, :gt) 
      exp = p_start
    end
    
    if not self.end.blank? 
      p_end = get_predicate('date_taken', self.end, :lt) 
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
    
    Photo.joins(:location).where(exp)
    
  end
  
  
  private
  
  def get_predicate(col, value, predicate)
    Squeel::Nodes::Predicate.new(Squeel::Nodes::Stub.new(col), predicate, value)
  end  
  
  
end
