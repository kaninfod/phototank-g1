class AdministrationController < ApplicationController

  def list_jobs
    failed_jobs = [
      '/media/exthdx/phototank/photos/2015/06/25/21ec85077d3e4adf41c8826164593ed5.jpg',
      '/media/exthdx/phototank/photos/2015/06/24/8108183b48c68c80a1822fdd7790fc94.jpg',
      '/media/exthdx/phototank/photos/2015/06/19/9adf618352865f74ba7895ce714c6825.jpg'
    ]
    failed_jobs.each do |fpath|
      Resque.enqueue(MasterImportPhotoJob, fpath)
    end
  end

  def generate_albums
    Resque.enqueue(GenerateAlbums)
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
