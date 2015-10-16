# encoding: utf-8

class EventManager

  attr_accessor :begin_time, :event_queue, :trace_file, :interval_time, :verbose

  Process = Struct.new(:name, :pid ,:size, :units) do
  end

  Event = Struct.new(:type, :time, :process, :address) do
    def to_s
      string = "#{time}s --> #{type} "
      string += "NAME: #{process.name} PID: #{process.pid} " if !process.nil?
      string += "ADDR: #{address} PAGE: #{address>>4}" if !address.nil?
      string
    end
  end

  def initialize
    @verbose = false
    @begin_time = nil
    @trace_file = nil
    @last_time = nil
    @event_queue = []
  end

  @@instance = EventManager.new

  def self.instance
    return @@instance #EVENT MANAGER IS A SINGLETON CLASS
  end

  def set_trace_file path
    @trace_file = path

    parse_trace_file path
  end

  def set_interval_time interval_time
    reset_time = MemoryManager.instance.replace_algorithm.get_inverval_time()
    if reset_time != 0
      reset_r_qnt =  (@simulation_time.to_f / reset_time).floor
      (1..reset_r_qnt).each do |i|
        @event_queue << Event.new('reset_r', i*reset_time)
      end
    end

    print_event_qnt =  (@simulation_time.to_f / interval_time).floor
    (1..print_event_qnt).each do |i|
      @event_queue << Event.new('print_status', i*interval_time)
    end    

    @event_queue.sort_by!.with_index { |e, id| [e.time, id] }
  end

  def start_simulation
    @begin_time = Time.now
    while !@event_queue.empty? do
     event = @event_queue.shift
      next_time = event.time - (Time.now - @begin_time)
      sleep(next_time) if next_time > 0.0
      puts event.to_s if @verbose
      MemoryManager.instance.send(event.type, event)
    end
  end

  def parse_trace_file path
    trace_file = File.new(path, 'r')
    trace_file.gets #DISCARD THE FIRST LINE
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

    @event_queue.sort_by!.with_index { |e, id| [e.time, id] }
    @simulation_time = @event_queue.last.time
    @event_queue << Event.new('end_simulation', @simulation_time + 1)
  end
end
