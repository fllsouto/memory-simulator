module Replace
  class ReplaceBase

    attr_accessor :page_table, :frame_table

    def initialize page_table, physical_mem_size
      @page_table = page_table
      @frames_qnt = physical_mem_size / 16
      @frame_table = Array.new(@frames_qnt, -1)
      frame_bit_qnt = (Math.log2(@frames_qnt)).ceil
      @f_bit_mask = (1 << frame_bit_qnt) - 1
      @p_bit_mask = 1 << frame_bit_qnt
      @r_bit_mask = 1 << (frame_bit_qnt + 1)
    end

    def free_frame_table frame
      @frame_table[frame] = -1
    end

    def access_frame frame
    end

    def self.get_inverval_time
      return 0
    end

    def print_structure
    end

  end

  class NotRecentlyUsed < ReplaceBase
    def initialize page_table, physical_mem_size
      super(page_table, physical_mem_size)
    end

    def choose_frame new_page
      zero_class = []
      one_class = []
      (0...@frames_qnt).each do |f|
        
        if @frame_table[f] == -1
          @frame_table[f] = new_page
          return [f, -1] 
        end

        r_bit = @page_table[@frame_table[f]] & @r_bit_mask
        
        if r_bit.zero?
          zero_class.push(f)
        else
          one_class.push(f)
        end
      end

      if !zero_class.empty?
        frame_n = zero_class[Random.rand(zero_class.size)]
      else
        frame_n = one_class[Random.rand(one_class.size)]
      end
      old_page = @frame_table[frame_n]
      @frame_table[frame_n] = new_page
      [frame_n, old_page]
    end

    def self.get_inverval_time
      return 4
    end

    def reset_r
      @frame_table.each do |page_n|
      @page_table[page_n] &= ~@r_bit_mask
      end
    end
  end

  class FirstInFirstOut < ReplaceBase
    def initialize page_table, physical_mem_size
      super(page_table, physical_mem_size)
      @frame_queue = LinkedList.new(Node)
      @free_frames = @frames_qnt
    end

    def choose_frame new_page
      if @free_frames > 0
        (0...@frames_qnt).each do |f|
          if @frame_table[f] == -1
            @frame_table[f] = new_page
            @frame_queue.enqueue(f)
            @free_frames -= 1
            return [f, -1] 
          end
        end
      end
      frame = @frame_queue.pop.value
      @frame_queue.enqueue(frame)
      old_page = @frame_table[frame]
      @frame_table[frame] = new_page
      return [frame, old_page]
    end

    def free_frame_table frame
      @frame_queue.delete_node(frame)
      @free_frames += 1
      super(frame)
    end

    def print_structure
      puts "FRAME QUEUE"
      puts @frame_queue.to_s
    end

  end

  class SecondChance < ReplaceBase

    attr_accessor :frame_queue

    def initialize page_table, physical_mem_size
      super(page_table, physical_mem_size)
      @frame_queue = LinkedList.new(Node)
      @free_frames = @frames_qnt
    end

    def choose_frame new_page
      if @free_frames > 0
        (0...@frames_qnt).each do |f|
          if @frame_table[f] == -1
            @frame_table[f] = new_page
            @frame_queue.enqueue(f)
            @free_frames -= 1
            return [f, -1] 
          end
        end
      end

      frame = nil
      loop do
        frame = @frame_queue.pop.value
        @frame_queue.enqueue(frame)
        page = @frame_table[frame]
        r_bit = @page_table[page] & @r_bit_mask
        @page_table[page] &= ~@r_bit_mask
        break if r_bit == 0
      end

      old_page = @frame_table[frame]
      @frame_table[frame] = new_page
      return [frame, old_page]
    end

    def free_frame_table frame
      @frame_queue.delete_node(frame)
      @free_frames += 1
      super(frame)
    end

    def print_structure
      puts "FRAME QUEUE"
      puts @frame_queue.to_s
    end

  end

  class LeastRecentlyUsed < ReplaceBase

    attr_accessor :matrix_frame

    def initialize page_table, physical_mem_size
      super(page_table, physical_mem_size)
      @matrix_frame = Array.new(@frames_qnt)
      @matrix_frame.map! { Array.new(@frames_qnt, 0) }
      @free_frames = @frames_qnt
    end

    def choose_frame new_page
      if @free_frames > 0
        (0...@frames_qnt).each do |f|
          if @frame_table[f] == -1
            @frame_table[f] = new_page
            @free_frames -= 1
            return [f, -1] 
          end
        end
      end

      min = 2**(@frames_qnt + 1)
      frame = -1
      (0...@frames_qnt).each do |f|
        num = @matrix_frame[f].join.to_i(2)
        if(num < min)
          frame = f
          min = num
        end
      end
      @matrix_frame[frame] = [0]*@frames_qnt
      old_page = @frame_table[frame]
      @frame_table[frame] = new_page
      return [frame, old_page]
    end

    def free_frame_table frame 
      @matrix_frame[frame] = [0]*@frames_qnt
      @free_frames += 1
      super(frame)
    end

    def access_frame frame
      @matrix_frame[frame] = [1]*@frames_qnt
      @matrix_frame.each{|l| l[frame] = 0}
    end

    def print_structure
      puts "MATRIX FRAME"
      @matrix_frame.each{|l| puts "#{l.to_s} -- #{l.join.to_i(2)}"}
    end

  end

  Algorithm = {
    '1' => NotRecentlyUsed,
    '2' => FirstInFirstOut,
    '3' => SecondChance,
    '4' => LeastRecentlyUsed
  }
end
