class AdministrationController < ApplicationController

  def generate_timebased_albums
    byebug
    distinct_years = Photo.pluck(:date_taken).map{|x| x.year}.uniq.each do |rec|
      album = Album.new
      album.name = 'Photos taken in ' + rec.to_s
      album.start = Date.new(rec.to_i, 1, 1)
      album.end = Date.new(rec.to_i, 12, 31)
      album.save
    end

    distinct_months = Photo.pluck(:date_taken).map{|x| Date.new(x.year, x.month, 1)}.uniq.each do |rec|
      album = Album.new
      #tart_date = Date.parse rec
      album.name = 'Photos taken in ' + rec.strftime("%b %y")
      album.start = rec
      album.end = (rec >> 1) -1
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
