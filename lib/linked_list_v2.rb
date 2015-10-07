require 'pry'
class LinkedList

  attr_accessor :head
  def initialize head
    @head = head
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
      printf "[#{aux.params}] "
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

  attr_accessor :nprev, :nnext, :params
  def initialize nprev, nnext, params
    @nnext = nnext
    @nprev = nprev
    @params = params
  end

end

list = LinkedList.new(nil)
list.enqueue(1)
list.enqueue(2)
list.enqueue(3)
list.enqueue(4)
list.show_list
binding.pry
list.enqueue_with_position(42, 1)
binding.pry
list.enqueue_with_position(43, 0)
binding.pry