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
    "[#{self.type}(#{self.pid}) -- #{self.init} : #{self.size}]"
  end

  def detail_node
    "(#{self.nprev.object_id}) <--[#{self.object_id}]#{self.to_mem}--> (#{self.nnext.object_id})"
  end

end

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