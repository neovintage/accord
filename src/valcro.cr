require "./valcro/*"

module Valcro
  macro included
    extend ClassMethods
  end

  def errors
    @errors ||= Valcro::ErrorList.new
  end

  def valid?
    !errors.any?
  end

  def validate
    errors.clear!
    self.class.validators.each do |validator_class|
      validator_class.new(self).call(errors)
    end
  end

  module ClassMethods
    macro extended
      @@validators = [] of Valcro::Validator.class
      @@validation_blocks = [] of Proc(Nil)
    end

    def validates_with(validator_class : Valcro::Validator.class)
      validators.push(validator_class)
    end

    def validators
      @@validators
    end
  end
end
