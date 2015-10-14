require_relative 'space_algorithm'
require_relative 'linked_list'
require_relative 'memory_list'
require_relative 'memory_manager'

def test_firstfit params, mem_list, space_algorithm
  params.shuffle!
  pparams = []
  p = params.shift
  pparams << p
  result = space_algorithm.find(mem_list, p)
  # binding.pry
  mem_list.set_process_on_free_position(p, result,space_algorithm)
  # binding.pry

  p = params.shift
  pparams << p
  result = space_algorithm.find(mem_list, p)
  # binding.pry
  mem_list.set_process_on_free_position(p, result,space_algorithm)
  # binding.pry

  p = params.shift
  pparams << p
  result = space_algorithm.find(mem_list, p)
  # binding.pry
  mem_list.set_process_on_free_position(p, result,space_algorithm)
  # binding.pry

  p = params.shift
  pparams << p
  result = space_algorithm.find(mem_list, p)
  # binding.pry
  mem_list.set_process_on_free_position(p, result,space_algorithm)
  # binding.pry  

  p = params.shift
  pparams << p
  result = space_algorithm.find(mem_list, p)
  # binding.pry
  mem_list.set_process_on_free_position(p, result,space_algorithm)
  # binding.pry  

  p = params.shift
  pparams << p
  result = space_algorithm.find(mem_list, p)
  # binding.pry
  mem_list.set_process_on_free_position(p, result,space_algorithm)
  # binding.pry

  p = params.shift
  pparams << p
  result = space_algorithm.find(mem_list, p)
  # binding.pry
  mem_list.set_process_on_free_position(p, result,space_algorithm)
  binding.pry
  pparams
  mem_list.release_process(1)
  mem_list.release_process(4)
  mem_list.release_process(7)  
end

def test_nextfit params, mem_list, space_algorithm
    params.shuffle!
  pparams = []
  p = params.shift
  pparams << p
  result = space_algorithm.find(mem_list, p)
  # binding.pry
  mem_list.set_process_on_free_position(p, result,space_algorithm)
  # binding.pry

  p = params.shift
  pparams << p
  result = space_algorithm.find(mem_list, p)
  # binding.pry
  mem_list.set_process_on_free_position(p, result,space_algorithm)
  # binding.pry

  p = params.shift
  pparams << p
  result = space_algorithm.find(mem_list, p)
  # binding.pry
  mem_list.set_process_on_free_position(p, result,space_algorithm)
  # binding.pry

  p = params.shift
  pparams << p
  result = space_algorithm.find(mem_list, p)
  # binding.pry
  mem_list.set_process_on_free_position(p, result,space_algorithm)
  # binding.pry  

  p = params.shift
  pparams << p
  result = space_algorithm.find(mem_list, p)
  # binding.pry
  mem_list.set_process_on_free_position(p, result,space_algorithm)
  # binding.pry  

  p = params.shift
  pparams << p
  result = space_algorithm.find(mem_list, p)
  # binding.pry
  mem_list.set_process_on_free_position(p, result,space_algorithm)
  # binding.pry

  p = params.shift
  pparams << p
  result = space_algorithm.find(mem_list, p)
  # binding.pry
  mem_list.set_process_on_free_position(p, result,space_algorithm)
  binding.pry
  pparams
  mem_list.release_process(1)
  mem_list.release_process(4)
  mem_list.release_process(7)
end

def test_quickfit params, mem_list, space_algorithm
end

params = [
  {pid: 1, size:  3,  type: 'P'},
  {pid: 2, size:  7,  type: 'P'},
  {pid: 3, size:  8,  type: 'P'},
  {pid: 4, size:  5,  type: 'P'},
  {pid: 5, size:  2,  type: 'P'},
  {pid: 6, size:  6,  type: 'P'},
  {pid: 7, size:  1,  type: 'P'}
  # {pid: 4, init: 37, size: 23,  type: 'P'}
]
# binding.pry
mem_spec =   {pid: -1, init: 0, size:  32,  type: 'L'} 
mem_list = MemoryList.new(mem_spec[:size])
mem_list.enqueue(mem_spec)

# binding.pry

space_algorithm = Space::FirstFit.new

case space_algorithm
when Space::FirstFit

  test_firstfit(params, mem_list, space_algorithm)
when Space::NextFit

  test_nextfit(params, mem_list, space_algorithm)
when Space::QuickFit

  test_quickfit(params, mem_list, space_algorithm)
end

# binding.pry
# # params.shuffle!
# # binding.pry
# p = params.shift
# result = Space::NextFit.new.find(mem_list, p)
# # binding.pry
# mem_list.set_process_on_free_position(p, result)
# # binding.pry

# p = params.shift
# result = Space::NextFit.new.find(mem_list, p)
# # binding.pry
# mem_list.set_process_on_free_position(p, result)
# # binding.pry

# p = params.shift
# result = Space::NextFit.new.find(mem_list, p)
# # binding.pry
# mem_list.set_process_on_free_position(p, result)
# # binding.pry

# p = params.shift
# result = Space::NextFit.new.find(mem_list, p)
# # binding.pry
# mem_list.set_process_on_free_position(p, result)
# # binding.pry

# # binding.pry
# p = params.shift
# result = Space::NextFit.new.find(mem_list, p)
# # binding.pry
# mem_list.set_process_on_free_position(p, result)
# binding.pry

# # binding.pry
# p = params.shift
# result = Space::NextFit.new.find(mem_list, p)
# # binding.pry
# mem_list.set_process_on_free_position(p, result)
# # binding.pry

# # binding.pry
# p = params.shift
# result = Space::NextFit.new.find(mem_list, p)
# # binding.pry
# mem_list.set_process_on_free_position(p, result)
# # mem_list.release_process()
# binding.pry
# mem_list.release_process(1)
# mem_list.release_process(4)
# mem_list.release_process(7)
# mem_list.compact_free_positions

# binding.pry
# k = {pid: 9, size:  2,  type: 'P'}
# result = Space::NextFit.new.find(mem_list, k)
# mem_list.set_process_on_free_position(k, result)
# binding.pry
# mem_list.release_process()

# mem_list.set_process_on_free_position(params[2], mem_list.head.nnext)
# mem_list.set_process_on_free_position(params[3], mem_list.head.nnext.nnext)
# # mem_list.set_process_on_free_position(params[4], mem_list.head.nnext.nnext.nnext)
# mem_list.set_process_to_free_position(mem_list.head)
# binding.pry
# # mem_list.set_process_to_free_position(mem_list.head.nnext.nnext)
# binding.pry
# mem_list.set_process_to_free_position(mem_list.head.nnext)
# binding.pry
# mem_list.compact_free_positions
# binding.pry

# space_algorithm = Space::QuickFit.new(mem_list)

# p = params.shift
# result = space_algorithm.find(mem_list, p)
# # binding.pry
# mem_list.set_process_on_free_position(p, result, space_algorithm)
# binding.pry