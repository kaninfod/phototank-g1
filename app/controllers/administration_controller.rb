class AdministrationController < ApplicationController

  def list_jobs
    failed_jobs = [
      '/media/exthdx/phototank/photos/2015/12/16/37b333e7a5c5e3424c3049e43436113d.jpg',
      '/media/exthdx/phototank/photos/2015/12/16/7653e19d75b2f0f8b81c5f07a8a173df.jpg',
      '/media/exthdx/phototank/photos/2015/12/13/086f7f5690dc48715221770e49e598e5.jpg',
      '/media/exthdx/phototank/photos/2015/12/13/e6032547a9f7318e1905b3174d56c0a5.jpg'
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
