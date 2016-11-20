require "spec"
require "../src/accord"

class TestClass
  include Accord
end

alias StatusFailValidatorTypes = StatusModel | MultipleValidatorModel

class StatusFailValidator < Accord::Validator
  def initialize(context : StatusFailValidatorTypes)
    @context = context
  end

  def call(errors)
    errors.add(:status, "big mistake") if @context.status == "fail"
  end
end

class StatusModel
  include Accord
  property status

  @status = "fail"

  validates_with [
    StatusFailValidator
  ]

end

class MultipleValidatorModel
  include Accord
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
  include Accord
  property awesome
  @awesome = "yes"

  def validate
    errors.add(:base, "Not awesome") if awesome == "no"
  end
end
