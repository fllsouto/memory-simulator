# encoding: utf-8

class MemoryManager

  attr_accessor :space, :replace

  def initialize
    @physical_mem_size = nil
    @virtual_mem_size = nil
    @space = nil
    @replace = nil
  end

  @@instance = MemoryManager.new

  def self.instance
    return @@instance
  end

  def self.new_method
    return @@instance
  end

  def set_mem_sizes physical, virtual
    @physical_mem_size = physical
    @virtual_mem_size = virtual

    puts "Initializing physical memory with #{physical} bytes"
    physical_mem_file = File.new('ep2.mem', 'wb')
    physical_mem_file.write(([-1]*physical).pack('c*'))
    physical_mem_file.close

    puts "Initializing virtual memory with #{virtual} bytes"
    virtual_mem_file = File.new('ep2.vir', 'wb')
    virtual_mem_file.write(([-1]*virtual).pack('c*'))
    virtual_mem_file.close
  end
end
