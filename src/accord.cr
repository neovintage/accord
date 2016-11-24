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
    @@validators = {
      {% for validator in validator_array %}
        {{ validator }},
      {% end %}
    }

    def self.validators
      @@validators
    end

    def validate_global
      {% for validator in validator_array %}
        {{ validator }}.new(self).call(errors)
      {% end %}
    end
  end
end
