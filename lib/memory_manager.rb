# encoding: utf-8

require "thread"
require 'pry'

require_relative 'space_algorithm'
require_relative 'linked_list'
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

class MemoryList < LinkedList

  attr_accessor :lfp

  def set_process_on_free_position params, f_pos
    return if (f_pos.nil? || f_pos.type == 'P')
    if f_pos.size >= params[:size]
      if params[:size] == f_pos.size
        node = Node.new(nil, nil, params)

        if(f_pos == f_pos.nnext)
          nnext     = node
          nprev     = node
          self.head = node
        else
          nnext       = f_pos.nnext
          nprev       = f_pos.nprev
          nnext.nprev = node
          nprev.nnext = node
        end
        node.nnext  = nnext
        node.nprev  = nprev
        node.init   = f_pos.init
        f_pos.nnext = nil
        f_pos.nprev = nil
      else
        node = Node.new(nil, nil, params)
        if(f_pos == f_pos.nnext)
          node.nnext  = f_pos
          node.nprev  = f_pos
          f_pos.nnext = node
          f_pos.nprev = node
          self.head   = node
        else
          nprev       = f_pos.nprev
          node.nprev  = nprev
          nprev.nnext = node
          node.nnext  = f_pos
          f_pos.nprev = node
          self.head   = node if f_pos == self.head
        end
        node.init  = f_pos.init
        f_pos.size = f_pos.size - params[:size]
        f_pos.init = params[:size] + f_pos.init
      end
    end
  end

  def set_process_to_free_position proc
    node = Node.new(nil, nil, {type: 'L', pid: -1})
    self.head = node if self.head == proc

    nnext       = proc.nnext
    nprev       = proc.nprev
    node.nnext  = nnext
    nnext.nprev = node
    node.nprev  = nprev
    nprev.nnext = node

    node.nprev  = proc.nprev
    node.init   = proc.init
    node.size   = proc.size
    proc.nnext  = nil
    proc.nprev  = nil
  end

  def release_process pid
    aux = self.head
    loop do
      if(aux.type == 'P' and aux.pid == pid)
        set_process_to_free_position(aux)
        return true
      end
      aux = aux.nnext
      break if aux == self.head
    end
  return false
  end

  def join_free_positions a, b
    return if (a == b)
    nnext = b.nnext
    a.size += b.size
    a.nnext = nnext
    nnext.nprev = a
    b.nnext = nil
    b.nprev = nil
  end

  def compact_free_positions
    aux = self.head
    loop do
      if (aux.nnext != self.head)
        if (aux.type == 'L' and aux.nnext.type == 'L')
          self.join_free_positions(aux, aux.nnext)
        else
          aux = aux.nnext
        end
      else
        break
      end
    end
  end
end

params = [
  {pid: -1, init: 0, size:  32,  type: 'L'},
  {pid: 1, size:  3,  type: 'P'},
  {pid: 2, size:  7,  type: 'P'},
  {pid: 3, size:  8,  type: 'P'},
  {pid: 4, size:  5,  type: 'P'},
  {pid: 5, size:  2,  type: 'P'},
  {pid: 6, size:  6,  type: 'P'},
  {pid: 7, size:  1,  type: 'P'}
  # {pid: 4, init: 37, size: 23,  type: 'P'}
]
binding.pry
p = params.shift
mem_list = MemoryList.new
mem_list.enqueue(p)

# params.shuffle!
# binding.pry
p = params.shift
result = Space::NextFit.new.find(mem_list, p)
# binding.pry
mem_list.set_process_on_free_position(p, result)
# binding.pry

p = params.shift
result = Space::NextFit.new.find(mem_list, p)
# binding.pry
mem_list.set_process_on_free_position(p, result)
# binding.pry

p = params.shift
result = Space::NextFit.new.find(mem_list, p)
# binding.pry
mem_list.set_process_on_free_position(p, result)
# binding.pry

p = params.shift
result = Space::NextFit.new.find(mem_list, p)
# binding.pry
mem_list.set_process_on_free_position(p, result)
# binding.pry

# binding.pry
p = params.shift
result = Space::NextFit.new.find(mem_list, p)
# binding.pry
mem_list.set_process_on_free_position(p, result)
# binding.pry

# binding.pry
p = params.shift
result = Space::NextFit.new.find(mem_list, p)
# binding.pry
mem_list.set_process_on_free_position(p, result)
# binding.pry

# binding.pry
p = params.shift
result = Space::NextFit.new.find(mem_list, p)
# binding.pry
mem_list.set_process_on_free_position(p, result)
# mem_list.release_process()
binding.pry
mem_list.release_process(1)
mem_list.release_process(4)
mem_list.release_process(7)
mem_list.compact_free_positions

binding.pry
k = {pid: 9, size:  2,  type: 'P'}
result = Space::NextFit.new.find(mem_list, k)
mem_list.set_process_on_free_position(k, result)
binding.pry
# mem_list.release_process()

# mem_list.set_process_on_free_position(params[2], mem_list.head.nnext)
# mem_list.set_process_on_free_position(params[3], mem_list.head.nnext.nnext)
# # mem_list.set_process_on_free_position(params[4], mem_list.head.nnext.nnext.nnext)
# mem_list.set_process_to_free_position(mem_list.head)
# binding.pry
# # mem_list.set_process_to_free_position(mem_list.head.nnext.nnext)
# binding.pry
# mem_list.set_process_to_free_position(mem_list.head.nnext)
# binding.pry
# mem_list.compact_free_positions
# binding.pry
