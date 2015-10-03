# encoding: utf-8

class ProcessManager

  def initialize
    @trace_file = nil
  end

  def set_trace_file path
    @trace_file = path

    # load trace's content into data structures
  end
end
