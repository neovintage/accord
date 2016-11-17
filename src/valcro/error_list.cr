module Valcro
  class ErrorList

    def initialize
      @errors = [] of Valcro::Error
    end

    def any?
      @errors.any?
    end

    def add(prop : Symbol, message : String)
      @errors << Valcro::Error.new(prop, message)
    end

    def [](prop)
      @errors.select { |error| error.attr == prop }.map(&.message) || [] of String
    end

    def clear!
      @errors = [] of Valcro::Error
    end
  end
end
