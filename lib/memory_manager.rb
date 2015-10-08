# encoding: utf-8

require "thread"
require 'pry'

class MemoryManager

  attr_accessor :space, :replace, :queue
  
  OFFSET = 4

  def initialize
    @physical_mem_size = nil
    @virtual_mem_size = nil
    @space = nil
    @replace = nil
    @exit_simulation = false
    @queue = Queue.new
    @process_table = {}
    @frame_number_bits = nil
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
    
    virtual_page = virtual / 16
    @page_entries = Array.new(virtual_pages_qnt, 0)
    
    physical_pages = physical / 16
    @frame_number_bits = (Math.log2(physical_pages)).ceil
    
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
    process = event.process
    base = @space.allocate_process process
    @process_table[process.pid] = {base: base}
  end

  def memory_access event
    local_addr = event.address
    virtual_addr = @process_table[pid][base] + local_addr
  
    page = virtual_addr >> OFFSET
    entry = @page_entries[page]
    frame_number = 
    present = (entry >> @frame_number_bits) & 0x0001
  end

  def finish_process event
    process = event.process
    @space.free_process process
    @process_table[process.pid] = nil
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
