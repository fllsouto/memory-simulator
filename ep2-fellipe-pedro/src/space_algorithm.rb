module Space
  class SpaceBase

    PAGE_SIZE = 16

    attr_accessor :mem_list

    def initialize virtual_mem_size
      virtual_mem_units = virtual_mem_size / PAGE_SIZE
      @mem_list = MemoryList.new(virtual_mem_units)
    end

    def release_process pid
      aux = @mem_list.head
      loop do
        if(aux.type == 'P' and aux.pid == pid)
          return @mem_list.set_process_to_free_position(aux)
        end
        aux = aux.nnext
        break if aux == @mem_list.head
      end
      return nil
    end

  end

  class FirstFit < SpaceBase
    def find_free_space proc
      free_space = find(proc.units)
      if(free_space)
        init = free_space.init
        @mem_list.set_process_on_free_position(proc, free_space)
        return init*PAGE_SIZE
      else
        return -1
      end
    end

    def find size
      aux = @mem_list.head
      loop do
        return aux if(aux.type == 'L' and aux.size >= size)
        aux = aux.nnext
        break if aux == @mem_list.head
      end
      return nil
    end

    def free_process proc
      release_process(proc.pid)
    end
  end

  class NextFit < SpaceBase
    def initialize virtual_mem_size
      super(virtual_mem_size)
      @last_pos = @mem_list.head
    end

    def find_free_space proc
      free_space = find(proc.units)
      if(free_space)
        init = free_space.init
        proc_node, free_node = @mem_list.set_process_on_free_position(proc, free_space)
        @last_pos = proc_node.nnext
        return init*PAGE_SIZE
      else
        return -1
      end
    end

    def find size
      aux = @last_pos
      loop do
        if(aux.type == 'L' and aux.size >= size)
          return aux
        end
        aux = aux.nnext
        break if aux == @last_pos
      end
      @mem_list.lfp = nil
      return nil
    end

    def free_process proc
      flag = (@last_pos != @mem_list.head && @last_pos.nprev.pid == proc.pid)
      free_pos = release_process(proc.pid)
      @last_pos = free_pos if flag
    end
  end

  class QuickFit < SpaceBase
    MAX = 16000

    attr_accessor :free_vector

    def initialize virtual_mem_size
      @vec_size = MAX / PAGE_SIZE
      @free_vector = Array.new(@vec_size)
      @free_vector.map! { LinkedList.new(FreeMemoryNode)}
      super(virtual_mem_size)
      insert(@mem_list.head)
    end

    def find_free_space proc
      free_space = find(proc.units)
      if(free_space)
        init = free_space.init
        proc_node, free_node = @mem_list.set_process_on_free_position(proc, free_space)
        if(free_node)
          insert(free_node)
        end
        return init*PAGE_SIZE
      else
        return -1
      end
    end

    def find size
      (size...@vec_size).each do |i|
        list = @free_vector[i-1]
        if list.head != nil
          return list.pop.f_mem_node
        end
      end
      return nil
    end

    def insert free_node
      index = free_node.size
      @free_vector[index-1].enqueue(free_node)
    end

    def free_process proc
      free_pos = release_process(proc.pid)
    end

    def release_process pid
      aux = @mem_list.head
      loop do
        if(aux.type == 'P' and aux.pid == pid)
          nprev = aux.nprev
          nnext = aux.nnext
          @free_vector[nprev.size-1].delete_node(nprev) if aux != @mem_list.head && nprev.type == 'L'
          @free_vector[nnext.size-1].delete_node(nnext) if aux.nnext != @mem_list.head && nnext.type == 'L'
          
          free_node = @mem_list.set_process_to_free_position(aux)
          insert(free_node)
          return
        end
        aux = aux.nnext
        break if aux == @mem_list.head
      end
      return nil
    end

  end

  Algorithm = {
    '1' => FirstFit,
    '2' => NextFit,
    '3' => QuickFit
  }
end
