require 'pry'

class LinkedList

  attr_accessor :val, :nnext

  def initialize nnext, val
    @nnext = nnext
    @val  = val
  end

  #insert value on the beginning of the list
  def self.push value, head
    if(head.nil?)
      return LinkedList.new(nil, value)
    else
      return LinkedList.new(head, value)
    end
  end

  #insert value in the end of the list
  def self.enqueue value, head
    if(head.nil?)
      return LinkedList.new(head, value)
    else
      head.nnext = LinkedList.enqueue(value, head.nnext)
      return head
    end
  end

  #remove value on the beginning of the list
  def self.pop head
    aux  = head
    if(aux != nil)
      head = head.nnext
      val = aux.val
    else
      val = nil
    end
    return [val, head]
  end

  # alias :dequeue :self.pop



  def self.size head
    aux = head
    c = 0
    while aux != nil
      aux = aux.nnext
      c += 1
    end
    return c
  end

  def self.print head
    aux = head
    c = 0
    
    if aux.nil?
      puts "EMPTY"
      return
    end

    while aux != nil
      printf "[#{aux.val}] "
      aux = aux.nnext
      c += 1
    end
  end
end

# t = Array(1..4)
# head = nil
# t.shuffle.each do |v|
#   head = LinkedList.push(v, head)
# end

# LinkedList.print(head)

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
