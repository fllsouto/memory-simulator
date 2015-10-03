require 'pry'

class LinkedList

  attr_accessor :pid, :init, :size, :type, :nnext, :nprev

  def initialize nnext, nprev, params
    @nnext  = nnext
    @nprev  = nprev
    @pid    = params[:pid]
    @init   = params[:init]
    @size   = params[:size]
    @type   = params[:type]
  end

  #insert value on the beginning of the list
  def self.push head, params
    if(head.nil?)
      head = LinkedList.new(nil, nil, params)
      head.nnext = head
      head.nprev = head
      return head
    else
      tail = head.nprev
      new_node = LinkedList.new(nil, nil, params)
      head.nprev     = new_node
      new_node.nnext = head
      new_node.nprev = tail
      tail.nnext     = new_node
      return new_node
    end
  end

def self.enqueue head, params
  if(head.nil?)
      head = LinkedList.new(nil, nil, params)
      head.nnext = head
      head.nprev = head
      return head
  else
    tail = head.nprev
    new_node = LinkedList.new(nil, nil, params)
    head.nprev     = new_node
    new_node.nnext = head
    new_node.nprev = tail
    tail.nnext     = new_node
    return head
  end
end

  #remove value on the beginning of the list
  def self.pop head
    aux  = head
    if(aux != nil)
      tail       = head.nprev
      head       = head.nnext
      head.nprev = tail
      tail.nnext = head
      aux.nnext  = nil
      aux.nprev  = nil
      params     = aux.to_params
    else
      params = nil
    end
    return [params, head]
  end


  def self.size head
    aux = head
    c = 0
    while aux != nil
      aux = aux.nnext
      c += 1
    end
    return c
  end

  def self.print head, type='direct'
    aux = head
    c = 0
    
    if aux.nil?
      puts "EMPTY"
      return
    end

    if(type == 'direct')
      puts "\nDirect Print"
      loop do
        printf "[#{aux.val}] "
        aux = aux.nnext
        c += 1
        break if aux == head
      end
    elsif(type == 'reverse')
      puts "\nReverse Print"
      loop do
        printf "[#{aux.val}] "
        aux = aux.nprev
        c += 1
        break if aux == head
      end
    end    
  end

  def to_params
    return {
      pid: self.pid, 
      init: self.init, 
      size: self.size, 
      type: self.type
    }
  end

end

t = Array(1..4)
head = nil

params = [
  {pid: 1, init: 0, size:  10,  type: 'P'},
  {pid: 2, init: 10, size:  5,  type: 'L'},
  {pid: 3, init: 15, size: 22,  type: 'P'},
  {pid: 4, init: 37, size: 23,  type: 'P'}
]
t.each_with_index do |v, i|
  head = LinkedList.enqueue(head, params[i])
end

binding.pry


# LinkedList.print(head)
# LinkedList.print(head, 'reverse')

# binding.pry

# puts "List size before : #{LinkedList.size(head)}"

# (val, head) = LinkedList.pop(head)
# puts "Poped value : #{val}"

# puts "List size after : #{LinkedList.size(head)}"
  
# LinkedList.print(head)


# (val, head) = LinkedList.pop(head)
# puts "Poped value : #{val}"

# puts "List size after : #{LinkedList.size(head)}"
  
# LinkedList.print(head)

# (val, head) = LinkedList.pop(head)
# puts "Poped value : #{val}"

# head = LinkedList.enqueue(1, head)
# head = LinkedList.enqueue(2, head)
# head = LinkedList.enqueue(3, head)
# LinkedList.print(head)
# binding.pry
# (val, head) = LinkedList.pop(head)
# puts "Dequeu value : #{val}"
# LinkedList.print(head)
# binding.pry
