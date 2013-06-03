##################
#example usage
##################

require './queue.rb'

class EchoJob

  def call(message)
    puts message
  end

end

10.times { |n| Work.enqueue(EchoJob, "I counted to #{n}") }

# Process jobs in another thread(s)
Work.start

# Block until all jobs are processed
Work.drain

# Stop the workers
Work.stop
