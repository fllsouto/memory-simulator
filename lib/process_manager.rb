# encoding: utf-8
require "awesome_print"

class ProcessManager

  attr_accessor :event_queue

  Event = Struct.new(:type, :time, :name, :pid, :size, :address)

  def initialize
    @trace_file = nil
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

  def parse_trace_file path
    trace_file = File.new(path, 'r')
    trace_file.gets #discard first line
    index = 0
    while ((line = trace_file.gets) != nil) do
      args = line.split
      # t0 nome tf b p1 t1 p2 t2 p3 t3 [pn tn]

      time = args.shift.to_i

      name = args.shift
      pid = index += 1

      finish = args.shift.to_i

      size = args.shift.to_i
      @event_queue << Event.new('start_process', time, name, pid, size)

      @event_queue << Event.new('finish_process', finish, name, pid)

      while args.size > 1 do
        address, time = args.shift(2).map(&:to_i)

        @event_queue << Event.new('memory_access', time, name, pid, nil, address)
      end
    end

    @event_queue.sort { |a, b| a.time <=> b.time}
  end
end
