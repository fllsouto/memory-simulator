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
    "[#{@type}(#{@pid}) -- #{@init} : #{@size}]"
  end

  def detail_node
    "(#{@nprev.object_id}) <--[#{self.object_id}]#{self.to_mem}--> (#{@nnext.object_id})"
  end
end

class FreeMemoryNode < Node

  attr_accessor :f_mem_node

  def initialize nprev, nnext, f_mem_node
    @f_mem_node = f_mem_node
    super(nprev, nnext)
  end

  def equals node
    return true if self.f_mem_node == node
    return super(node)
  end

  def to_s
    @f_mem_node.to_s
  end
end

class MemoryList < LinkedList

  attr_accessor :lfp, :vmu

  def initialize virtual_mem_units
    @vmu = virtual_mem_units
    super(MemoryNode)
    self.enqueue({pid: -1, init: 0, size:  virtual_mem_units,  type: 'L'})
  end

  def set_process_on_free_position proc, f_pos
    return nil if (f_pos.nil? || f_pos.type == 'P')
    if f_pos.size >= proc.units
      params = {pid: proc.pid, init: f_pos.init, size: proc.units, type: 'P'}
      if proc.units == f_pos.size
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
        return [node, nil]
      else
        node = @node_class.new(nil, nil, params)
        if(f_pos == f_pos.nnext)
          node.nnext  = f_pos
          node.nprev  = f_pos
          f_pos.nnext = node
          f_pos.nprev = node
          self.head   = node
        else
          binding.pry if f_pos.nprev.nil? 
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
        return [node, f_pos]
      end
    end
  end

  def join_free_positions a, b
    return if (a == b)
    nnext = b.nnext
    a.size += b.size
    a.nnext = nnext
    nnext.nprev = a
    b.nnext = nil
    b.nprev = nil
    a
  end

  def set_process_to_free_position node
    node.type = 'L'
    node.pid = -1

    if node.nnext != self.head && node.nnext.type == 'L'
      join_free_positions node, node.nnext
    end

    if node != self.head && node.nprev.type == 'L'
      node = join_free_positions node.nprev, node
    end

    node
  end
end
