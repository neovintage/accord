module Accord
  abstract class Validator
    abstract def call(errors : Accord::ErrorList)
  end
end
