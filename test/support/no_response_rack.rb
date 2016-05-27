class NoResponseRack
  attr_reader :requests

  def initialize disconnected_mode
    @disconnected_mode = disconnected_mode

    @requests = []
    @sleeping_threads = []
  end

  def call(env)
    @requests.push(env)

    case @disconnected_mode
    when :elb_pool_empty
      @sleeping_threads << Thread.current
      sleep 65
      @sleeping_threads.delete Thread.current
      [504, {}, ['']]
    when :server_maintenance
      [200, {}, ['status_message=Atlas is down for maintenance.']]
    else
      [999, {}, [""]]
    end
  end

  def wakeup_sleeping_threads
    @sleeping_threads.each &:wakeup
    @sleeping_threads.clear
  end
end