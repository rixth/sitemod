module Sitemod
  class ModDataManager
    @@instance = nil

    attr_reader :mod_directories
    attr_reader :sitemod_path

    def reload_mod_directories!
      if File.directory?(@sitemod_path)
        @mod_directories = Dir.glob(@sitemod_path + "/**/*/").map do |dir|
          trim_base(dir)
        end
      end
    end

    def mods_in_directory(site)
      path = @sitemod_path + '/' + site
      mod_files = {
        "js" => Dir[path + '/*.js'] + Dir[path + '/*.coffee'],
        "css" => Dir[path + '/*.css'] + Dir[path + '/*.scss']
      }

      mod_files.keys.each do |mod_type|
        mod_files[mod_type].map! do |file|
          trim_base(file)
        end
      end

      mod_files
    end

    def self.instance
      @@instance = self.new unless @@instance
      @@instance
    end

    private
    def initialize
      @sitemod_path = File.expand_path('~') + '/.sitemods'
      @mod_directories = []
    end

    def trim_base(str)
      str.sub(/^#{Regexp.escape(sitemod_path)}\/?/, '').sub(/\/$/, '')
    end
  end
end