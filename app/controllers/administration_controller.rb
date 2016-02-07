class AdministrationController < ApplicationController
  
  def generate_timebased_albums
    
    distinct_years = Photo.select("strftime('%Y', date_taken) as year").distinct.each do |rec|
      album = Album.new
      album.name = 'Photos taken in ' + rec.year.to_s
      album.start = Date.new(rec.year.to_i, 1, 1)
      album.end = Date.new(rec.year.to_i, 12, 31)
      album.save

    end

    distinct_months = Photo.select("strftime('%Y-%m-01', date_taken) as year").distinct.each do |rec|
      album = Album.new
      start_date = Date.parse rec.year
      album.name = 'Photos taken in ' + start_date.strftime("%b %y")
      album.start = start_date
      album.end = (start_date >> 1) -1
      album.save

    end


    redirect_to '/albums'

  end

  def jobs_pending
    @info = Resque.info
    Resque.queues.each do |queue|
      @info[queue] = Resque.size(queue)
    end
    workers=[]
    Resque.workers.each do |worker| 
      workers.push({worker => worker.working?})
      
    end
    @info["workers"] = workers
    respond_to do |format|
      format.html { }
      format.json { render json: @info }
    end
    
  
  end
end
