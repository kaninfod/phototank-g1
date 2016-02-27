require 'dropbox_sdk'

class SynchronizersController < ApplicationController

  APP_KEY = 'knb2b9w893ilrlj'
  APP_SECRET = 'bqsdycbxph2bqdm'
  REDIRECT_URI = "http://localhost:3000/synchronizers/dpres"

  def dpres
    byebug
    flow = DropboxOAuth2Flow.new(APP_KEY, APP_SECRET,REDIRECT_URI, session, :dropbox_auth_csrf_token)
    access_token, user_id, url_state = flow.finish(params)
    render :html => params
  end

  def authorize()
    byebug

    flow = DropboxOAuth2Flow.new(APP_KEY, APP_SECRET,REDIRECT_URI, session, :dropbox_auth_csrf_token)
    authorize_url = flow.start()
    redirect_to authorize_url


  end


  def dropbox

    access_token = 'UFefx_vmXWwAAAAAAAKYUjujc9-a8rdTeQHz_2vfgewJqvaHCByQ9Xe3_fM2T7Tm'
    dropbox_client = login(access_token)

    Photo.all.each do |photo|
      file_path_local = File.join(photo.default_instance, photo.path, photo.filename + photo.file_extension)
      file_path_dropbox = File.join('/', 'rails', photo.path, photo.filename + photo.file_extension)

      begin
        response = dropbox_client.metadata(file_path_dropbox)
      rescue
        response = dropbox_client.put_file(file_path_dropbox, open(file_path_local))
        puts response

      else
        puts 'exists'

        if response['bytes'] == photo.file_size.to_i
          puts 'same size'
        else
          response = dropbox_client.put_file(file_path_dropbox, open(file_path_local))
          puts response
        end
      end



    end

    render :nothing => true




  end

  private

  def login(access_token)

    client = DropboxClient.new(access_token)
    return client

  end


end
