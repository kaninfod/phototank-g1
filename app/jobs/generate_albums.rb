class GenerateAlbums
  @queue = :utility

  def self.perform()

    begin
      Album.generate_year_based_albums
      Album.generate_month_based_albums
      Album.generate_inteval_based_albums
    rescue Exception => e
      raise "An error occured: #{e}"
    end

  end
end
