module Space
  class FirstFit

    def find mem_list, proc
      aux = mem_list.head
      loop do
        binding.pry
        return aux if(aux.type == 'L' and aux.size >= proc[:size])
        aux = aux.nnext
        break if aux == mem_list.head
      end
      return nil
    end
  end

  class NextFit

    LIMIT = 3

    def find mem_list, proc
      aux = get_lfp(mem_list)
      loop do
        if(aux.type == 'L' and aux.size >= proc[:size])
          mem_list.lfp = (reset_lfp?(aux.size, proc[:size])) ? mem_list.head : aux
          return aux
        end
        aux = aux.nnext
        break if aux == mem_list.head
      end
      mem_list.lfp = nil
      return nil
    end

    def reset_lfp? a, b
      return false if (a - b > LIMIT)
      return true
    end

    def get_lfp mem_list
      if(!mem_list.lfp.nil? and !mem_list.lfp.nnext.nil? and !mem_list.lfp.nprev.nil?)
        return mem_list.lfp
      else
        return mem_list.head
      end
    end
  end

  class QuickFit

  end

  Algorithm = {
    '1' => FirstFit,
    '2' => NextFit,
    '3' => QuickFit
  }
end
