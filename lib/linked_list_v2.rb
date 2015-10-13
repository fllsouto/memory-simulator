require 'pry'
class LinkedList

  attr_accessor :head
  def initialize
    @head = nil
  end

  def enqueue  params
    if(self.head.nil?)
      self.head = Node.new(nil, nil, params)
      self.head.nnext = self.head
      self.head.nprev = self.head
    else
      tail = self.head.nprev
      new_node = Node.new(nil, nil, params)
      self.head.nprev     = new_node
      new_node.nnext = self.head
      new_node.nprev = tail
      tail.nnext     = new_node
    end
  end

  def show_list
    aux = self.head
    loop do
      printf "[#{aux.to_mem}] "
      aux = aux.nnext
      break if aux == self.head
    end
  end

  def show_details_list
    aux = self.head
    loop do
      puts aux.detail_node
      aux = aux.nnext
      break if aux == self.head
    end
  end

  def enqueue_with_position params, position
    return if position < 0 
    c = 0
    aux = self.head
    loop do
      if(c == position)
        new_node = Node.new(aux.nprev, aux, params)
        nprev = aux.nprev
        nprev.nnext = new_node
        aux.nprev = new_node
        self.head = new_node if (position == 0)
      end
      c += 1
      aux = aux.nnext
      break if(aux == self.head || c > position)
    end
  end

  def set_process_on_free_position params, f_pos
    return if f_pos.type == 'P'
    
    if params[:init] == f_pos.init
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
        end
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

  def join_free_positions a, b
    return if (a == b)
    binding.pry
    nnext = b.nnext
    a.size += b.size
    a.nnext = nnext
    nnext.nprev = a
    binding.pry

    b.nnext = nil
    b.nprev = nil
  end

  def compact_free_positions
    aux = self.head
    loop do
    self.join_free_positions(aux, aux.nnext) if (aux.type == 'L' and aux.nnext.type == 'L')
    aux = aux.nnext
    break if (aux == self.head)
    end 

  end
end

class Node

  attr_accessor :nprev, :nnext, :pid, :init, :size, :type
  def initialize nprev, nnext, params
    @nnext = nnext
    @nprev = nprev
    @pid =  params[:pid]
    @init = params[:init]
    @size = params[:size]
    @type = params[:type]
  end
  def to_s
   puts "\nPID : #{self.pid}, \nInit : #{self.init}, \nSize : #{self.size}, \nType : #{self.type}"
  end

  def to_mem
    "[#{self.type} -- #{self.init} : #{self.size}]"
  end

  def detail_node
    "(#{self.nprev.object_id}) <--[#{self.object_id}]#{self.to_mem}--> (#{self.nnext.object_id})"
  end

end

params = [
  {pid: -1, init: 0, size:  16,  type: 'L'},
  {pid: 1, init: 0, size:  16,  type: 'P'},
  {pid: 2, init: 0, size:  6,  type: 'P'},
  {pid: 3, init: 6, size: 3,  type: 'P'},
  {pid: 4, init: 9, size:  6,  type: 'P'},
  {pid: 5, init: 15, size:  1,  type: 'P'}
  # {pid: 4, init: 37, size: 23,  type: 'P'}
]
list = LinkedList.new
list.enqueue(params.shift)

binding.pry
list.set_process_on_free_position(params[1], list.head)
list.set_process_on_free_position(params[2], list.head.nnext)
list.set_process_on_free_position(params[3], list.head.nnext.nnext)
list.set_process_on_free_position(params[4], list.head.nnext.nnext.nnext)
list.set_process_to_free_position(list.head)
binding.pry
list.set_process_to_free_position(list.head.nnext)
binding.pry
list.compact_free_positions
binding.pry

# a = {init: 0, size: 16}
# b11 = {init: 0, size: 16}
# b12 = {init: 0, size: 4}
# c21 = {init: 4, size: 12}
# c22 = {init: 4, size: 4}

# teste = [
#   [b11, a],
#   [b12, a],
#   [c21, a],
#   [c22, a]
# ]

# teste.each do |v|
#   puts '-'*100
#   LinkedList.set_process_on_free_position(v[0], v[1])
#   puts '-'*100
# end

# list = LinkedList.new
# list.enqueue(1)
# list.enqueue(2)
# list.enqueue(3)
# list.enqueue(4)
# list.show_list
# list.enqueue_with_position(42, 1)
# binding.pry
# list.enqueue_with_position(43, 0)
# binding.pry