require 'rubygems'
require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'])

require 'sinatra/base'

class Shortener < Sinatra::Base
  PATH_MAPS = {
    '' => '',
    'biz' => 'business',
    'a' => 'about',
    'j' => 'jobs',
    'stupid' => 'https://github.com/danhixon/stupid-url-shortener'
  }
  
  # API:
  get '/api/short_id/:id' do
    short_path_for_resource(params[:id])
  end
  
  get '/api/url/:id' do
    h = request.host
    h += ":#{request.port}" if request.port != 80
    "http://#{h}/#{short_path_for_resource(params[:id])}"
  end
  
  # static paths:
  PATH_MAPS.each do |short, long|
    get "/#{short}" do
      redirect (long=~/https?:/) ? long : "#{redirect_host}/#{long}"
    end
  end
  
  get %r{/!?(.+)} do |id|
    redirect "#{redirect_host}/#{resource}/#{id.base62_decode}"
  end

  def short_path_for_resource(id)
    path = id.to_i.base62_encode
    # if there is a conflict then prepend it with !
    PATH_MAPS[path] ? "!#{path}" : path
  end
  
  def redirect_host
    ENV['REDIRECT_HOST'] || "http://twitter.com"
  end
  
  def resource
    ENV['RESOURCE_NAME'] || "#!/whoever/status"
  end
  
end