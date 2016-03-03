class AdministrationController < ApplicationController

  def list_jobs
    failed_jobs = [
      '/media/exthdx/phototank/photos/2015/07/12/3ceaeee65bbbc7dca40635d6ca5e5cc6.jpg',
      '/media/exthdx/phototank/photos/2015/06/28/7abdf206cfee64dedb297254703d43ef.jpg',
      '/media/exthdx/phototank/photos/2015/06/28/d03e409355f3155828a19c7e5a9b6a1d.jpg'    ]
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
