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
      # Security check
      halt 400 if params[:splat].first['..']

      path = File.expand_path(params[:splat].first, ModDataManager.instance.sitemod_path)
      raise ::Sinatra::NotFound unless path && File.exist?(path)
      ext = File.extname(path)
      
      content_type 'text/plain'
      content_type 'text/javascript' if %w{.js .coffee}.include?(ext)
      content_type 'text/css' if %w{.css .sass .scss}.include?(ext)
      content_type 'text/html' if %w{.html .haml .slim}.include?(ext)

      Tilt[ext.sub(/^\./, '')] ? Tilt.new(path).render : File.read(path)
    end
  end
end