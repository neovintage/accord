module Valcro
  abstract class Validator
    abstract def call(errors : Valcro::ErrorList)
  end
end
