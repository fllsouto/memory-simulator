require 'pry'
require_relative 'linked_list'

class MemoryNode < Node

  attr_accessor :pid, :init, :size, :type

  def initialize nprev, nnext, params
    @pid =  params[:pid]
    @init = params[:init]
    @size = params[:size]
    @type = params[:type]
    super(nprev, nnext)
  end

  def to_s
   puts "\nPID : #{@pid}, \nInit : #{@init}, \nSize : #{@size}, \nType : #{@type}"
  end

  def to_mem
    "[#{@type}(#{@pid}) -- #{@init} : #{@size}]"
  end

  def detail_node
    "(#{@nprev.object_id}) <--[#{self.object_id}]#{self.to_mem}--> (#{@nnext.object_id})"
  end
end

class FreeMemoryNode < Node

  attr_accessor :fmn

  def initialize nprev, nnext, fmn
    @fmn = fmn
    super(nprev, nnext)
  end
end

class MemoryList < LinkedList

  attr_accessor :lfp, :vmu

  def initialize virtual_mem_units
    @vmu = virtual_mem_units
    super(MemoryNode)
    self.enqueue({pid: -1, init: 0, size:  virtual_mem_units,  type: 'L'})
  end

  def set_process_on_free_position params, f_pos
    return nil if (f_pos.nil? || f_pos.type == 'P')
    if f_pos.size >= params[:size]
      if params[:size] == f_pos.size
        node = @node_class.new(nil, nil, params)

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
        return nil
      else
        node = @node_class.new(nil, nil, params)
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
        return f_pos
      end
    end
  end

  def set_process_to_free_position proc
    node = @node_class.new(nil, nil, {type: 'L', pid: -1})
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
