require 'pry'

class LinkedList

  attr_accessor :nnext, :nprev

  def initialize nnext, nprev
    @nnext  = nnext
    @nprev  = nprev
  end

  #insert value on the beginning of the list
  def self.push head, params
    if(head.nil?)
      head = self.new(nil, nil, params)
      head.nnext = head
      head.nprev = head
      return head
    else
      tail = head.nprev
      new_node = self.new(nil, nil, params)
      head.nprev     = new_node
      new_node.nnext = head
      new_node.nprev = tail
      tail.nnext     = new_node
      return new_node
    end
  end

def self.enqueue head, params
  if(head.nil?)
      head = self.new(nil, nil, params)
      head.nnext = head
      head.nprev = head
      return head
  else
    tail = head.nprev
    new_node = self.new(nil, nil, params)
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
    return {}
  end

end

class MemoryList < LinkedList

  attr_accessor :pid, :init, :size, :type

  def initialize nnext, nprev, params
    @pid    = params[:pid]
    @init   = params[:init]
    @size   = params[:size]
    @type   = params[:type]
    super(nnext, nprev)
  end

  def self.is_free_segment? head, init, size
    
    aux = head
    return true if head == nil

    loop do
      if(aux.type == 'L' && init >= aux.init && init + size < aux.end)  
        return true
      else
        aux = aux.nnext
      end
      break if aux == head
    end
    return false
  end

  def set_process
  end

  def remove_process
  end

  def join_free_segment
  end

  def show_memory
    aux = self
    puts "-"*140
    puts "\n"
    loop do
      printf "[#{aux.type} (#{aux.init} : #{aux.size})]"
      aux = aux.nnext
      break if aux == self 
    end
    puts "\n"
    puts "-"*140
  end

  def to_params
    {    
      pid: self.pid, 
      init: self.init, 
      size: self.size, 
      type: self.type
    }.merge(super)
  end

  def end
    self.init + self.size
  end

  def self.enqueue head, params
    # if(MemoryList.is_free_segment?(head, params[:init], params[:size]))
    #   binding.pry
    return super(head, params)
    # else
    #   binding.pry
    # end
  end

  def self.enqueue_with_position head, params, position
    c = 0
    aux = head
    loop do
      binding.pry
      if(c == position)
        MemoryList.enqueue(aux, params)
        binding.pry
      end
      c += 1
      aux = aux.nnext
      break if(aux == head || c > position)
    end
    return head
  end

end

# t = Array(1..4)
head = nil

params = [
  {pid: -1, init: 0, size:  32,  type: 'L'},
  {pid: 2, init: 10, size:  6,  type: 'P'},
  {pid: 3, init: 4, size: 5,  type: 'P'},
  {pid: 2, init: 0, size:  9,  type: 'P'}
  # {pid: 4, init: 37, size: 23,  type: 'P'}
]
params.each do |param|
  head = MemoryList.enqueue(head, param)
end
binding.pry
a = {pid: 5, init: 13, size:  9,  type: 'P'}
head = MemoryList.enqueue_with_position(head, a, 1)
binding.pry
a = {pid: 5, init: 10, size:  1,  type: 'P'}
head = MemoryList.enqueue_with_position(head, a, 0)
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
