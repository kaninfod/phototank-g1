class AdministrationController < ApplicationController

  def list_jobs
    failed_jobs = [
      '/media/exthdx/phototank/photos/2015/06/07/5193049342b33f6d9d3c3f54c676c9af.jpg',
      '/media/exthdx/phototank/photos/2015/06/07/ba3cdee2fd13b1079baf26d0c07fbf84.jpg',
      '/media/exthdx/phototank/photos/2015/06/07/76be9f5dd0681f0be1e548ae48089da3.jpg',
      '/media/exthdx/phototank/photos/2015/06/03/ab9dc0621511a0304145496baa0f747d.jpg',
      '/media/exthdx/phototank/photos/2015/06/06/8476c3ac57f1d7d464aa480d39f6ef84.jpg',
      '/media/exthdx/phototank/photos/2015/05/23/a426e572355a2ba2c496a6c006ceb49d.jpg',
      '/media/exthdx/phototank/photos/2015/05/01/ef7673be3e1fc5650120882b1ea4c6b2.jpg'
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
