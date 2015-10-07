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
    binding.pry
    if params[:init] == f_pos.init
      if params[:size] == f_pos.size
        
        binding.pry
        puts "Caso 1.1 mesmo fim"
        node = Node.new(f_pos.nprev, f_pos, params)
        f_pos.nnext = nil
        f_pos.nprev = nil
      else
        binding.pry
        nprev = f_pos.nprev

        node = Node.new(nil, nil, params)
        node.nprev = f_pos.nprev
        node.nnext = f_pos

        f_pos.nprev = node
        f_pos.init = params[:size]
        #object_id
        puts "Caso 1.2 fim diferente"
      end
    elsif params[:init] > f_pos.init
      puts "Caso 2 inicio diferente"
      if(params[:init] + params[:size] == f_pos.init + f_pos.size)
        binding.pry
        nprev = f_pos.nprev

        node = Node.new(nil, nil, params)
        node.nnext = f_pos.nnext
        node.nprev = f_pos

        f_pos.nnext = node
        f_pos.size = node.init

        puts "Caso 2.1 fim igual"
      else
        binding.pry
        nnext = f_pos.nnext

        node = Node.new(nil, nil, params)
        f_node = Node.new(nil, nil, nil)

        node.nnext = f_node 
        node.nprev = f_pos

        f_node.nnext  = nnext
        f_node.nprev  = node
        f_node.init   = node.init + node.size
        f_node.size   = f_pos.size - f_node.init 

        f_pos.nnext = node
        f_pos.size  = node.init
        puts "Caso 2.2 fim diferente"
      end
    end
    binding.pry
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

end

params = [
  {pid: -1, init: 0, size:  16,  type: 'L'},
  {pid: 2, init: 0, size:  6,  type: 'P'},
  {pid: 3, init: 4, size: 5,  type: 'P'},
  {pid: 2, init: 0, size:  9,  type: 'P'}
  # {pid: 4, init: 37, size: 23,  type: 'P'}
]
list = LinkedList.new
list.enqueue(params.shift)

binding.pry
list.set_process_on_free_position(params.shift, list.head)
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