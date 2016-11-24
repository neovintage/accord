module Accord
  class ErrorList

    def initialize
      @errors = [] of Accord::Error
    end

    def any?
      !@errors.empty?
    end

    def add(prop : Symbol, message : String)
      @errors << Accord::Error.new(prop, message)
    end

    def add(err : Accord::Error)
      @errors << err
    end

    def [](prop)
      @errors.select { |error| error.attr == prop }.map(&.message) || [] of String
    end

    def clear!
      @errors = [] of Accord::Error
    end

    def full_messages
      @errors.map do |err|
        err.to_s
      end
    end

    def size
      @errors.size
    end

    def each
      @errors.each do |error|
        yield error
      end
    end

    def +(error_list : Accord::ErrorList)
      new_list = Accord::ErrorList.new
      @errors.each do |err|
        new_list.add(err)
      end
      error_list.each do |err|
        new_list.add(err)
      end
      return new_list
    end
  end
end
