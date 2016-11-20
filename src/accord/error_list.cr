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
  end
end
