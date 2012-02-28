require 'sinatra'
require 'json'

module Sitemod
  class ModServer < ::Sinatra::Base
    get '/mods_for' do
      data_manager = ModDataManager.instance
      data_manager.reload_mod_directories!
      
      matcher = Matcher.instance
      matcher.directories = data_manager.mod_directories
      
      JSON.pretty_generate(matcher.get_directories_for_url(params[:url]).map do |dir|
        data_manager.mods_in_directory(dir)
      end.flatten)
    end

    get '/file/*' do
      path = params[:splat].first
      ext = path.split('.').last

      if ext == 'js'
        content_type 'text/javascript'
        File.read("/Users/trix/.sitemods/" + path)
      elsif ext == 'css'
        content_type 'text/css'
        File.read("/Users/trix/.sitemods/" + path)
      elsif ext == 'coffee'
        content_type 'text/javascript'
        Tilt.new("/Users/trix/.sitemods/" + path).render
      elsif ext == 'scss'
        content_type 'text/css'
        Tilt.new("/Users/trix/.sitemods/" + path).render
      else
        raise ::Sinatra::NotFound
      end
    end
  end
end