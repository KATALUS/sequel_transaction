module Sidekiq
  module Middleware
    module Client
      class AfterCommit
        def initialize(settings)
          @connection = settings.fetch(:connection)
        end

        def call(*args)
          @connection.after_commit do
            yield
          end
        end
      end
    end
  end
end
