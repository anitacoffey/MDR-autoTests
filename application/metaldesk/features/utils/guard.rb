class Guard
  def self.check_parameters(parameters)
    parameters.each do |p|
      if defined?(p).nil?
        raise 'Method called without all required arguements. Check the stack trace'
      end
    end
  end
end
