# encoding: utf-8

require "thread"
require 'pry'

class MemoryManager

  attr_accessor :space, :replace, :queue

  def initialize
    @physical_mem_size = nil
    @virtual_mem_size = nil
    @space = nil
    @replace = nil
    @exit_simulation = false
    @queue = Queue.new
  end

  @@instance = MemoryManager.new

  def self.instance
    return @@instance
  end

  def self.new_method
    return @@instance
  end

  def start_simulation
    puts "MemoryManager Thread: #{Thread.current}"
    loop do
      event = @queue.pop
      self.send(event.type, event)
      break if @exit_simulation
    end
  end

  def set_mem_sizes physical, virtual
    @physical_mem_size = physical
    @virtual_mem_size = virtual

    puts "Initializing physical memory with #{physical} bytes"
    physical_mem_file = File.new('ep2.mem', 'wb')
    physical_mem_file.write(([-1]*physical).pack('c*'))
    physical_mem_file.close

    puts "Initializing virtual memory with #{virtual} bytes"
    virtual_mem_file = File.new('ep2.vir', 'wb')
    virtual_mem_file.write(([-1]*virtual).pack('c*'))
    virtual_mem_file.close
  end

  def start_process event

  end

  def memory_access event

  end

  def finish_process event

  end


  def end_simulation event
    @exit_simulation = true
  end

  def print_status event
    puts "#{event.time}" #TODO verificar compartilhamento de singleton entre threads
  end

  def can_execute?
    @physical_mem_size && @virtual_mem_size && @space && replace
  end

end
