module Space
  class FirstFit

    attr_accessor :mem_list

    def initialize virtual_mem_size
      virtual_mem_units = virtual_mem_size / 16
      @mem_list = MemoryList.new(virtual_mem_units)
    end

    def find_free_space proc
      free_space = find(proc)
      if(free_space)
        init = free_space.init
        @mem_list.set_process_on_free_position(proc, free_space)
        return init
      else
        return -1
      end
    end

    def find proc
      aux = @mem_list.head
      loop do
        return aux if(aux.type == 'L' and aux.size >= proc[:size])
        aux = aux.nnext
        break if aux == @mem_list.head
      end
      return nil
    end

    def free_process proc
      @mem_list.release_process(proc.pid)
      @mem_list.compact_free_positions
    end
  end

  class NextFit

    #igual ao first fit
    LIMIT = 3

    def find proc
      aux = get_lfp(@mem_list)
      loop do
        if(aux.type == 'L' and aux.size >= proc[:size])
          @mem_list.lfp = (reset_lfp?(aux.size, proc[:size])) ? @mem_list.head : aux
          return aux
        end
        aux = aux.nnext
        break if aux == @mem_list.head
      end
      @mem_list.lfp = nil
      return nil
    end

    def reset_lfp? a, b
      return false if (a - b > LIMIT)
      return true
    end

    def get_lfp
      if(!@mem_list.lfp.nil? and !@mem_list.lfp.nnext.nil? and !@mem_list.lfp.nprev.nil?)
        return @mem_list.lfp
      else
        return @mem_list.head
      end
    end
  end

  class QuickFit

    #diferente do first fit pq tenho que inserir o cara que o set_process_on_free-pos no array de free_positions
    SLICE_SIZE = 16
    
    attr_accessor :mem_free_vector
    
    def initialize vmz
      @mem_free_vector = Array.new(vmz / SLICE_SIZE)
      @mem_free_vector.each{|v| v = LinkedList.new(FreeMemoryList)}
    end

    def find proc
      @mem_free_vector.each do |v|
        if !v.nil? and v.size >= proc[:size]
          return v.pop
        end
      end
      return nil
    end

    def insert f_proc
      return if f_proc.size < PAGE_SIZE 
      indx = f_proc.size / PAGE_SIZE - 1
      @mem_free_vector[indx].enqueue(f_proc)
    end

  end

  Algorithm = {
    '1' => FirstFit,
    '2' => NextFit,
    '3' => QuickFit
  }
end
