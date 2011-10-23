class YieldClass
  
  include Enumerable
  
  def initialize(*args, &generator_blk)
    @fib = Fiber.new do
      generator_blk.call(self, *args)
      raise StopIteration
    end
    
  end
  
  def next
    @fib.resume
  end
  
  def each
    unless block_given?
      self
    else
      loop {  
        yield self.next
      }
    end
  end
  
  def _yield(value)
    Fiber.yield value
  end
  
end

lambda {
  
  generators = {}
  
  #we will run our methods in that obejct's context
  context_object = Object.new
  
  def context_object.wrap_enum(generator, *args)
    YieldClass.new(*args, &generator)
  end
  
  Kernel.send :define_method, :generator do |name, *args, &block|
      if block.nil?
        puts "The args are #{args}"
        return context_object.wrap_enum(generators[name], *args)
      end
      generators[name] = block
      
  end

}.call

