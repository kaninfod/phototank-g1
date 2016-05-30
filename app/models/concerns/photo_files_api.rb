require "net/http"
require "uri"

URL = Rails.configuration.x.phototank["filestoreurl"]

module PhotoFilesApi
  class Api
    def initialize

    end

    def show(id)
      endpoint = "/photofiles/#{id}.json"

      http = get_http
      request = Net::HTTP::Get.new(endpoint)
      response = http.request(request)
      JSON.parse(response.body, {:symbolize_names => true}) if response.code == "200"
    end

    def create(path, datehash)
      endpoint = "/photofiles.json"

      file_string = Base64.encode64(File.open(path).read)
      payload = datehash
      payload[:file_string]= file_string

      http = get_http
      request = Net::HTTP::Post.new(endpoint)
      request.set_form_data(payload)
      response = http.request(request)

      if response.code == "200"
        JSON.parse(response.body, {:symbolize_names => true})
      else
        return false
      end
    end

    def update(id, path)
      endpoint = "/photofiles/#{id}.json"

      file_string = Base64.encode64(File.open(path).read)

      payload= {:file_string => file_string}

      http = get_http
      request = Net::HTTP::Put.new(endpoint)
      request.set_form_data(payload)
      response = http.request(request)

      JSON.parse(response.body, {:symbolize_names => true}) if response.code == "200"
    end

    def destroy(id)
      endpoint = "/photofiles/#{id}.json"

      http = get_http
      request = Net::HTTP::Delete.new(endpoint)
      response = http.request(request)

      JSON.parse(response.body, {:symbolize_names => true}) if response.code == "200"
    end

    def phash(id)
      endpoint = "/photofiles/#{id}/phash.json"

      http = get_http
      request = Net::HTTP::Get.new(endpoint)
      response = http.request(request)
      JSON.parse(response.body) if response.code == "200"
    end

    def rotate(id, degrees)
      byebug
      endpoint = "/photofiles/#{id}/rotate.json"

      http = get_http
      request = Net::HTTP::Patch.new(endpoint)
      request.set_form_data({:degrees => degrees})
      response = http.request(request)

      JSON.parse(response.body, {:symbolize_names => true}) if response.code == "200"
    end

    def generate_datehash(date)
      datestring = date.strftime("%Y%m%d%H%M%S")
      unique = [*'a'..'z', *'A'..'Z', *0..9].shuffle.permutation(5).next.join

      datehash = {
        :datestring=>datestring,
        :unique=>unique,
        :year=>date.year,
        :month=>date.month,
        :day=>date.day
      }
      return datehash
    end

    private


    def get_http
      uri = URI.parse(URL)
      http = Net::HTTP.new(uri.host, uri.port)
    end

  end
end
