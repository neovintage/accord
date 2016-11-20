require "./accord/*"

module Accord
  def validate!
    errors.clear!
    if self.responds_to?(:validate_global)
      self.validate_global
    end
    if self.responds_to?(:validate)
      self.validate
    end
  end

  def errors
    @errors ||= Accord::ErrorList.new
  end

  def valid?
    !errors.any?
  end

  macro validates_with(validator_array)
    @@validators = {{ validator_array }}
    protected def validate_global
      @@validators.each do |v|
        v.new(self).call(errors)
      end
    end
  end
end
