module Rack
  class SequelTransaction
    def initialize(inner, settings)
      @inner = inner
      @connection = settings.fetch(:connection)
    end

    def call(env)
      @connection.transaction do
        result = @inner.call env
        response = Response.new([], result[0])
        err = env['sinatra.error']

        if err || response.client_error? || response.server_error?
          raise Sequel::Rollback
        end
        result
      end
    end
  end
end
