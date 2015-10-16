# encoding: utf-8

require_relative 'space_algorithm'
require_relative 'linked_list'
require_relative 'memory_list'

class MemoryManager

  attr_accessor :space_algorithm, :replace_algorithm, :verbose

  VIRTUAL_MEM = '/tmp/ep2.vir'
  PHYSICAL_MEM = '/tmp/ep2.mem'
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
    return @@instance #MEMORY MANAGER IS A SINGLETON CLASS
  end

  def start_simulation
    @space = @space_algorithm.new(@virtual_mem_size)
    @replace = @replace_algorithm.new(@page_table, @physical_mem_size)
  end

  def set_mem_sizes physical, virtual
    @physical_mem_size = physical
    @virtual_mem_size = virtual

    virtual_pages_qnt = virtual / PAGE_SIZE
    @page_table = Array.new(virtual_pages_qnt, 0) # [unused_bits][M][R][P][page_frame_number]

    physical_pages_qnt = physical / PAGE_SIZE
    frame_bit_qnt = (Math.log2(physical_pages_qnt)).ceil

    @f_bit_mask = (1 << frame_bit_qnt) - 1
    @p_bit_mask = 1 << frame_bit_qnt
    @r_bit_mask = 1 << (frame_bit_qnt + 1)

    puts "Initializing physical memory with #{physical} bytes"
    IO.write(PHYSICAL_MEM, ([-1]*physical).pack('c*'))

    puts "Initializing virtual memory with #{virtual} bytes"
    IO.write(VIRTUAL_MEM, ([-1]*virtual).pack('c*'))
  end

  def start_process event
    proc = event.process
    proc.units = (proc.size / PAGE_SIZE.to_f).ceil
    free_space_base = @space.find_free_space proc
    @process_table[proc.pid] = {base: free_space_base}
    proc_byte_string = ([proc.pid]*proc.units*PAGE_SIZE).pack('c*')
    IO.write(VIRTUAL_MEM, proc_byte_string, free_space_base)
  end

  def memory_access event
    local_addr = event.address
    virtual_addr = @process_table[event.process.pid][:base] + local_addr

    new_page_n = virtual_addr >> Math.log2(PAGE_SIZE)
    entry = @page_table[new_page_n]
    present = entry & @p_bit_mask
    if present != 0
      @page_table[new_page_n] = entry | @r_bit_mask
      @replace.access_frame entry & @f_bit_mask 
    else
      page_content = IO.read(VIRTUAL_MEM, PAGE_SIZE, new_page_n * PAGE_SIZE)
      frame_n , old_page_n = @replace.choose_frame new_page_n
      IO.write(PHYSICAL_MEM, page_content, frame_n * PAGE_SIZE)
      @page_table[new_page_n] = frame_n | @p_bit_mask
      @page_table[old_page_n] &= ~@p_bit_mask if old_page_n != -1
    end
  end

  def reset_r event
    @replace.reset_r
  end

  def finish_process event
    empty_page_bytes = ([-1]*PAGE_SIZE).pack('c*')

    proc = event.process
    base = @process_table[proc.pid][:base]
    # FREE SPACE STRUCTURE
    @space.free_process proc

    # FREE PAGING STRUCTURES
    (0...proc.units).each do |i|
      i += base / PAGE_SIZE
      entry = @page_table[i]
      @page_table[i] = 0
      if (entry & @p_bit_mask) != 0
        frame_n = entry & @f_bit_mask
        @replace.free_frame_table frame_n
        IO.write(PHYSICAL_MEM, empty_page_bytes, frame_n * PAGE_SIZE)
      end
    end
    # FREE MEM FYLE
    IO.write(VIRTUAL_MEM, empty_page_bytes * proc.units, base)
    # FREE PROCESS TABLE
    @process_table[proc.pid] = nil
  end

  def print_status event
    puts '--------------------------'
    
    puts "SPACE LINKED LIST"
    puts @space.mem_list.to_s
    
    if @verbose
      puts "PAGE TABLE"
      @page_table.each.with_index do |entry, i|
        printf "%2d [f:%2d p:%c r:%c]\n", i, entry&@f_bit_mask, entry&@p_bit_mask  == 0 ? ' ': 'X', entry&@r_bit_mask == 0 ? ' ': 'X'
      end
      
      puts "FRAME TABLE"
      puts @replace.frame_table.to_s

      @replace.print_structure
    end
    
    puts "\t\t:: MEMORIES ::"
    
    puts 'VIRTUAL MEMORY'
    print_memory VIRTUAL_MEM
    
    puts 'PHYSICAL MEMORY'
    print_memory PHYSICAL_MEM
    
    puts ""
    puts ""
  end

  def print_memory memory_file
    memory = IO.read(memory_file).unpack('c*')
    pages = memory.size / PAGE_SIZE
    (0...pages).each do |i|
      print "["
      printf '%3d', memory[i*PAGE_SIZE]
      (1...16).each do |j|
        printf ', %3d', memory[i*PAGE_SIZE + j]
      end
      puts ']'
    end
  end

  def can_execute?
    @physical_mem_size && @virtual_mem_size && @space_algorithm && replace_algorithm
  end

end
