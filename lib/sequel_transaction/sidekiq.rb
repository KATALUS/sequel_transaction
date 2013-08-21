Dir[File.expand_path("../sidekiq/*.rb", __FILE__)].each { |f| require f }
