# encoding: utf-8
require "awesome_print"
require "thread"

class ProcessManager

  attr_accessor :begin_time, :event_queue, :trace_file, :interval_time

  Process = Struct.new(:name, :pid, :size)

  Event = Struct.new(:type, :time, :process, :address) do
    def to_s
      "type : #{type}, \ntime : #{time}, \nname : #{process.name}, \npid : #{process.pid}, \nsize : #{process.size}, \naddress : #{address}"
    end
  end

  def initialize
    @begin_time = nil
    @trace_file = nil
    @last_time = nil
    @event_queue = []
  end

  @@instance = ProcessManager.new

  def self.instance
    return @@instance
  end

  def self.new_method
    return @@instance
  end

  def set_trace_file path
    @trace_file = path

    parse_trace_file path
  end

  def set_interval_time interval_time
    print_event_qnt =  (@simulation_time.to_f / interval_time).floor
    (1..print_event_qnt).each do |i|
      @event_queue << Event.new('print_status', i*interval_time)
    end
    @event_queue.sort! { |a, b| a.time <=> b.time}
  end

  def start_simulation
    puts "ProcessManager Thread: #{Thread.current}"
    @begin_time = Time.now
    while !@event_queue.empty? do
      next_event = @event_queue.shift
      next_time = next_event.time - (Time.now - @begin_time)
      sleep(next_time) if next_time > 0.0
      MemoryManager.instance.queue << next_event
    end
  end

  def parse_trace_file path
    trace_file = File.new(path, 'r')
    trace_file.gets #discard first line
    index = 0
    while ((line = trace_file.gets) != nil) do
      args = line.split

      # t0 nome tf b p1 t1 p2 t2 p3 t3 [pn tn]
      t0 = args.shift.to_i
      name = args.shift
      tf = args.shift.to_i
      size = args.shift.to_i
      pid = index += 1
      process = Process.new(name, pid, size)

      @event_queue << Event.new('start_process', t0, process)

      @event_queue << Event.new('finish_process', tf, process)

      while args.size > 1 do
        address, time = args.shift(2).map(&:to_i)

        @event_queue << Event.new('memory_access', time, process, address)
      end
    end



    @event_queue.sort! { |a, b| a.time <=> b.time}
    @simulation_time = @event_queue.last.time
    @event_queue << Event.new('end_simulation', @simulation_time + 1)
  end

  def event_debug event
    puts "#{Time.now}: Enviando evento #{event}\n "
  end
end
