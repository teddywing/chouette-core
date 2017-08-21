require 'result'

class RetryService

  Retry = Class.new(RuntimeError)

  # @param@ delays:
  # An array of delays that are used to retry after a sleep of the indicated
  # value in case of failed exceutions.
  # Once this array is exhausted the executen fails permanently
  #
  # @param@ rescue_from:
  # During execution all the excpetions from this array +plus RetryService::Retry+ are rescued from and
  # trigger just another retry after a `sleep` as indicated above.
  #
  # @param@ block:
  # This optional code is excuted before each retry, it is passed the result of the failed attempt, thus
  # an `Exception` and the number of execution already tried.
  def initialize( delays: [], rescue_from: [], logger: nil, &blk )
    @intervals             = delays
    @logger                = logger
    @registered_exceptions = Array(rescue_from) << Retry
    @failure_callback      = blk
  end

  # @param@ blk:
  # The code to be executed it will be retried goverened by the `delay` passed into the initializer
  # as described there in case it fails with one of the predefined exceptions or `RetryService::Retry`
  #
  # Eventually it will return a `Result` object.
  def execute &blk
    result = execute_protected blk
    return result if result.ok?
    @intervals.each_with_index do | interval, retry_count |
      warn "retry #{retry_count + 1 }; sleeping #{interval}; cause: #{result.value.inspect}"
      sleep interval
      @failure_callback.try(:call, result.value, retry_count + 1)
      result = execute_protected blk
      return result if result.ok?
    end
    result
  end


  private

  def execute_protected blk
    result = blk.()
    return result if Result === result
    Result.ok(result)
  rescue Exception => e
    if @registered_exceptions.any?{ |re| e.is_a? re }
      Result.error(e)
    else
      raise
    end
  end

  def warn message
    return unless @logger
    @logger.try :warn, message
  end
end
