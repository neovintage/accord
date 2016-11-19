require "spec"
require "../src/valcro"

class TestClass
  include Valcro
end

class StatusFailValidator < Valcro::Validator
  def initialize(context : StatusModel)
    @context = context
  end

  def call(errors : Valcro::ErrorList)
    errors.add(:status, "big mistake") if @context.status == "fail"
  end
end

class StatusModel
  include Valcro
  property status
  validates_with StatusFailValidator

  def status
    @status ||= "fail"
  end
end
