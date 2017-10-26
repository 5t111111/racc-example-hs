class HS
  def initialize(receiver:, method:, args:)
    @receiver = receiver
    @method = method
    @args = args

    def @receiver.method_missing(method, args)
      case method
      when :elem
        p args.include?(self.to_i)
      else
        raise NoMethodError
      end
    end
  end

  def call
    @receiver.send(@method, *@args)
  end
end

