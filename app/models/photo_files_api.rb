require "net/http"
require "uri"

URL = Rails.configuration.x.phototank["filestoreurl"]

module PhotoFilesApi

  def phash(id)
    endpoint = "/photofiles/#{id}/phash.json"

    http = get_http
    request = Net::HTTP::Get.new(endpoint)
    response = http.request(request)
    JSON.parse(response.body) if response.code == "200"
  end

  def rotate(id, degrees)
    endpoint = "/photofiles/#{id}/rotate.json"

    http = get_http
    request = Net::HTTP::Patch.new(endpoint)
    request.set_form_data({:degrees => degrees})
    response = http.request(request)

    JSON.parse(response.body) if response.code == "200"
  end




  private

  def get_http
    uri = URI.parse(URL)
    http = Net::HTTP.new(uri.host, uri.port)
  end

end
