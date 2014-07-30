module Sidekiq
  module Middleware
    module Server
      class Transaction
        def initialize(settings)
          @connection = settings.fetch(:connection)
        end

        def call(worker_class, message, queue)
          @connection.transaction do
            yield
          end
        end
      end
    end
  end
end
