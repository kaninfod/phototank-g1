class Photofile < ActiveRecord::Base
  attr_accessor :data, :url, :datehash
  validates :path, presence: true
  before_create :import_file
  before_destroy :delete_file

  PATH = Rails.configuration.x.phototank["filestorepath"]

  def import_file
    begin
      
      path = File.join(PATH, self.datehash[:year].to_s, self.datehash[:month].to_s,self.datehash[:day].to_s)
      FileUtils.mkdir_p File.join(path)
      filename = "#{datehash[:datestring]}_#{datehash[:type]}_#{datehash[:unique]}"
      filepath = File.join(path, filename)
      FileUtils.cp self.path, filepath
      self.path = filepath

    rescue Exception => e
      byebug
    end
  end

def delete_file
  FileUtils.rm self.path if File.exists? self.path
end

end
