# encoding: utf-8

require "thread"
require 'pry'

require_relative 'space_algorithm'
require_relative 'linked_list'
require_relative 'memory_list'
class MemoryManager

  attr_accessor :space, :replace, :queue

  VIRTUAL_MEM = 'ep2.vir'
  PHYSICAL_MEM = 'ep2.mem'
  PAGE_SIZE = 16

  def initialize
    @physical_mem_size = nil
    @virtual_mem_size = nil
    @space = nil
    @replace = nil
    @exit_simulation = false
    @queue = Queue.new
    @process_table = {}
    @frame_number_bits = nil
    @p_bit_mask = nil
    @r_bit_mask = nil
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

    @space = @space.new(@virtual_mem_size)
    loop do
      event = @queue.pop
      self.send(event.type, event)
      break if @exit_simulation
    end
  end

  def set_mem_sizes physical, virtual
    @physical_mem_size = physical
    @virtual_mem_size = virtual

    virtual_pages_qnt = virtual / PAGE_SIZE
    @page_table = Array.new(virtual_pages_qnt, 0) # [unused_bits][M][R][P][page_frame_number]

    physical_pages_qnt = physical / PAGE_SIZE
    @frame_number_size = (Math.log2(physical_pages_qnt)).ceil

    @p_bit_mask = 1 << @frame_number_size
    @r_bit_mask = 1 << @frame_number_size + 1

    puts "Initializing physical memory with #{physical} bytes"
    IO.write(PHYSICAL_MEM, ([-1]*physical).pack('c*'))

    puts "Initializing virtual memory with #{virtual} bytes"
    IO.write(VIRTUAL_MEM, ([-1]*virtual).pack('c*'))
  end

  def start_process event
    process = event.process
    free_space_base = @space.find_free_space process
    @process_table[process.pid] = {base: base}
    IO.write(VIRTUAL_MEM, ([process.pid]*process.size).pack('c*'), base)
  end

  def memory_access event
    local_addr = event.address
    virtual_addr = @process_table[pid][:base] + local_addr

    page_n = virtual_addr >> Math.log2(PAGE_SIZE)
    entry = @page_table[page_n]
    present = entry & @p_bit_mask
    if present == 1
      @page_table[page_n] = entry | @r_bit_mask
    else
      page_content = IO.read(VIRTUAL_MEM, PAGE_SIZE, page_n * PAGE_SIZE)
      frame_n = @replace.choose_frame
      IO.write(PHYSICAL_MEM, page_content, frame_n * PAGE_SIZE)
      @page_table[page_n] = frame_n | @p_bit_mask
    end
  end

  def finish_process event
    process = event.process
    @space.free_process process
    base = @process_table[process.pid][:base]
    IO.write(VIRTUAL_MEM, ([-1]*process.size).pack('c*'), base)
    @process_table[process.pid] = nil
  end


  def end_simulation event
    @exit_simulation = true
  end

  def print_status event
    puts @space.mem_list
  end

  def can_execute?
    @physical_mem_size && @virtual_mem_size && @space && replace
  end

end
