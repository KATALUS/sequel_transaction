module Sidekiq
  module Middleware
    module Client
      class AfterCommit
        def initialize(settings)
          @connection = settings.fetch(:connection)
        end

        def call(worker_class, message, queue)
          @connection.after_commit do
            yield
          end
        end
      end
    end
  end
end
