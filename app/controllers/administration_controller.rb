class AdministrationController < ApplicationController

  def list_jobs
    Resque::Failure.each do |j,p|
      if p.fetch('payload').fetch('class') == "PhotoProcessor"
        import_file_path = p.fetch('payload').fetch('args').first
        if File.file?(import_file_path)
          Resque.enqueue(MasterImportPhotoJob, import_file_path)
        end

      end
    end
    @failed_jobs = Resque::Failure.all(0,20)

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
