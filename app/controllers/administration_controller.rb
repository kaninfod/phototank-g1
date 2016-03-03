class AdministrationController < ApplicationController

  def list_jobs
    failed_jobs = [
      '/media/exthdx/phototank/photos/2015/12/13/c623470b9d0b52e7fb9fdfa05013c857.jpg',
      '/media/exthdx/phototank/photos/2015/12/02/1dafd577d2d0d2b375780aa306dca1e0.jpg',
      '/media/exthdx/phototank/photos/2015/08/09/36797ae8fddd42ae86e262a314dc362d.jpg'    ]
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
