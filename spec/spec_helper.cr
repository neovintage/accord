require "spec"
require "../src/valcro"

class TestClass
  include Valcro
end

alias StatusFailValidatorTypes = StatusModel | MultipleValidatorModel

class StatusFailValidator < Valcro::Validator
  def initialize(context : StatusFailValidatorTypes)
    @context = context
  end

  def call(errors)
    errors.add(:status, "big mistake") if @context.status == "fail"
  end
end

class StatusModel
  include Valcro
  property status

  @status = "fail"

  validates_with [
    StatusFailValidator
  ]

end

class MultipleValidatorModel
  include Valcro
  property works, status

  @works = true
  @status = "fail"

  validates_with [
    StatusFailValidator
  ]

  def validate
    errors.add(:works, "It didnt work") if works == false
  end
end

class InlineOnlyValidatorModel
  include Valcro
  property awesome
  @awesome = "yes"

  def validate
    errors.add(:base, "Not awesome") if awesome == "no"
  end
end
