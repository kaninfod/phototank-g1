class DoublesController < ApplicationController
  def find
    doubles_array = Array.new

    Photo.group(:date_taken).find_each(start: 4538) do |double|
      doubles_array.clear
      Photo.where("date_taken = ?", double.date_taken).find_each do |item|
        doubles_array.push(item.id)
      end
      entry = Double.new(items: doubles_array)
      entry.save

    end
  end
  
  def index
    @doubles = Double.where(deleted: nil)
  end
  
  def delete
    puts params[:photo_id], params[:doubles_id]
    entry = Double.find(params[:doubles_id])
    entry.deleted = params[:photo_id]
    entry.save
    puts entry.items
    
    redirect_to action: "index"
  end
end
