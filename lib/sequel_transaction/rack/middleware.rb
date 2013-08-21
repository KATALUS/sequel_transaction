module Rack
  class SequelTransaction
    def initialize(inner, settings)
      @inner = inner
      @connection = settings.fetch(:connection)
    end

    def call(env)
      req = Request.new env
      if req.get? || req.head? || req.options?
        result = @inner.call env
      else
        @connection.transaction do
          result = @inner.call env
          response = Response.new [], result[0]
          err = env['sinatra.error']

          if err || response.client_error? || response.server_error?
            raise Sequel::Rollback
          end
        end
      end
      result
    end
  end
end
