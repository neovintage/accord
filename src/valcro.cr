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
      klass = validator_class.new(self)
      klass.call(errors)
    end
    self.class.validation_blocks.each do |validation_block|
      run_proc &validation_block
    end
  end

  def run_proc
    with self yield
  end

  module ClassMethods
    macro extended
      @@validators = [] of Valcro::Validator.class
      @@validation_blocks = [] of Proc(Nil)
    end

    def validates_with(validator_class)
      validators << validator_class
    end

    def validators
      @@validators
    end

    def validation_blocks
      @@validation_blocks
    end

    def validate(&block : Proc(Void))
      @@validation_blocks << block
    end
  end
end
