require 'pry'

class LinkedList

  attr_accessor :head, :node_class
  def initialize node_class=Node
    @head = nil
    @node_class = node_class
  end

  def enqueue  params
    if(@head.nil?)
      @head = @node_class.new(nil, nil, params)
      @head.nnext = @head
      @head.nprev = @head
    else
      tail = @head.nprev
      new_node = @node_class.new(nil, nil, params)
      @head.nprev     = new_node
      new_node.nnext = @head
      new_node.nprev = tail
      tail.nnext     = new_node
    end
  end

  def pop
    delete_node @head
  end

  def delete_node node
    aux = @head
    if(aux != nil)
      loop do
        if(aux.equals(node))
          if (aux != aux.nnext)
            nprev = aux.nprev
            nnext = aux.nnext
            nprev.nnext = nnext
            nnext.nprev = nprev
            @head = nnext if aux == @head
          else
            @head = nil
          end
          aux.nnext = nil
          aux.nprev = nil
          return aux
        end
        aux = aux.nnext
        break if aux == @head
      end
    end
    return nil
  end 

  def to_s
    string = ""
    aux = @head
    if !aux.nil? 
      loop do 
        string += "[#{aux.to_s}] "
        aux = aux.nnext
        break if aux == @head
      end
    else
      string = "EMPTY"
    end
    string
  end

  def show_list
    puts to_s
  end

  def show_details_list
    aux = @head
    loop do
      puts aux.detail_node
      aux = aux.nnext
      break if aux == @head
    end
  end

  def enqueue_with_position params, position
    return if position < 0 
    c = 0
    aux = @head
    loop do
      if(c == position)
        new_node = @node_class.new(aux.nprev, aux, params)
        nprev = aux.nprev
        nprev.nnext = new_node
        aux.nprev = new_node
        @head = new_node if (position == 0)
      end
      c += 1
      aux = aux.nnext
      break if(aux == @head || c > position)
    end
  end

end

class Node

  attr_accessor :nprev, :nnext, :value
  def initialize nprev, nnext, value=nil
    @nnext = nnext
    @nprev = nprev
    @value = value
  end

  def equals node
    self == node
  end

  def to_s
    @value.to_s
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