require 'thread'
require 'timeout'

#based on excellent blog post at 
#http://therealadam.com/2012/06/19/getting-started-with-ruby-concurrency-using-two-simple-classes/

module Work
  @queue = Queue.new
  @n_threads = 2
  @workers = []
  @running = true

  Job = Struct.new(:worker, :params)

  module_function
  def enqueue(worker, *params)
    @queue << Job.new(worker, params)   #what is the <;<; syntax?
  end

  def start
    @workers = @n_threads.times.map { Thread.new { process_jobs } }
  end

  def process_jobs
    while @running
      job = nil
      Timeout.timeout(1) do
        job = @queue.pop
      end
      job.worker.new.call(*job.params)
    end
  end

  def drain
    loop do
      break if @queue.empty?
      #sleep 1
    end
  end

  def stop
    @running = false
    @workers.each(&:join)
  end

end

# ##################
# #example usage
# ##################

# 10.times { |n| Work.enqueue(EchoJob, "I counted to #{n}") }

# # Process jobs in another thread(s)
# Work.start

# # Block until all jobs are processed
# Work.drain

# # Stop the workers
# Work.stop


