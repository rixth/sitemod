require 'uri'

module Sitemod
  class Matcher
    @@instance = nil

    attr_accessor :directories

    def get_directories_for_url(url)
      uri = URI(url)
      (@directories || []).select { |directory| directory_matches_uri?(directory, uri) }
    end

    def directory_matches_uri?(directory, uri)
      uri = uri.dup

      # Remove any www from host
      uri.host.sub!(/^www\./, '')

      # Check for host mis-match (accounting for potential www)
      return false unless directory[/^(www\.)?#{Regexp.escape(uri.host)}($|\/)/]

      # Check paths, accounting for wildcards, and trailing wildcards
      directory_path = [*directory.sub(/^.+?($|\/)/, '').split('/')]
      uri_path = [*uri.path.gsub(/^\/|\/$/, '').split('/')]
      return false unless directory_path.zip(uri_path).all? do |bits|
        bits[0] == '*' || bits[0] == bits[1] || (directory_path.last == '*' && bits[1] != nil)
      end

      # If it hasn't bailed by now, it must be good, right?
      true
    end

    def self.instance
      @@instance = self.new unless @@instance
      @@instance
    end

    private
    def initialize
    end
  end
end