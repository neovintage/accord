module Accord
  class Error
    property attr, message

    def initialize(@attr : Symbol, @message : String)
    end

    def to_s
      if @attr == :base
        @message
      else
        "#{@attr.to_s} #{message}"
      end
    end
  end
end
