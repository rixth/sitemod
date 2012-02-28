module Sitemod
  Dir[File.expand_path('../sitemod/*.rb', __FILE__) ].each{ |f| require f }
end