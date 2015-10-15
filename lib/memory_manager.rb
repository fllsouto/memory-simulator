# encoding: utf-8

require "thread"
require 'pry'

require_relative 'space_algorithm'
require_relative 'linked_list'
require_relative 'memory_list'
class MemoryManager

  attr_accessor :space_algorithm, :replace_algorithm, :verbose

  VIRTUAL_MEM = 'ep2.vir'
  PHYSICAL_MEM = 'ep2.mem'
  PAGE_SIZE = 16

  def initialize
    @verbose = false
    @physical_mem_size = nil
    @virtual_mem_size = nil
    @space_algorithm = nil
    @space = nil
    @replace_algorithm = nil
    @replace = nil
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
    @space = @space_algorithm.new(@virtual_mem_size)
    @replace = @replace_algorithm.new
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
    proc = event.process
    proc.units = (proc.size / PAGE_SIZE.to_f).ceil #Convert size to allocation units
    free_space_base = @space.find_free_space proc
    @process_table[proc.pid] = {base: free_space_base}
    proc_byte_string = ([proc.pid]*proc.units*PAGE_SIZE).pack('c*')
    IO.write(VIRTUAL_MEM, proc_byte_string, free_space_base)
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
    proc = event.process
    @space.free_process proc
    base = @process_table[proc.pid][:base]
    empty_byte_string = ([-1]*proc.units*PAGE_SIZE).pack('c*')
    IO.write(VIRTUAL_MEM, empty_byte_string, base)
    @process_table[proc.pid] = nil
  end

  def print_status event
    puts '--------------------------'
    puts "LINKED LIST"
    puts @space.mem_list.to_s
    puts 'VIRTUAL MEMORY'
    virtual_mem = IO.read(VIRTUAL_MEM).unpack('c*')
    pages = virtual_mem.size / PAGE_SIZE
    (0...pages).each do |i|
      print '['
      printf '%2d', virtual_mem[i*PAGE_SIZE]
      (1...16).each do |j|
        printf ', %2d', virtual_mem[i*PAGE_SIZE + j]
      end
      puts ']'
    end
  end

  def can_execute?
    @physical_mem_size && @virtual_mem_size && @space_algorithm && replace_algorithm
  end

end
