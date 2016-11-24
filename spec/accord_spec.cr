require "./spec_helper"

describe Accord do
  it "is valid when no validations are defined" do
    test = TestClass.new
    (test.valid?).should eq(true)
    test.errors[:blah].should eq([] of String)
  end
end

describe Accord, "adding some errors" do
  it "give access to the error list" do
    test = TestClass.new
    test.errors.add(:blah, "blah blah")
    test.errors[:blah].size.should eq(1)
    test.errors[:blah].should eq(["blah blah"])
    (test.valid?).should be_false
  end
end

describe Accord, "validators" do
  it "can be added" do
    model = StatusModel.new
    model.validate!
    (model.valid?).should be_false
  end

  it "clears validations on subsequent runs" do
    model = StatusModel.new
    model.validate!
    (model.valid?).should be_false

    model.status = "win"
    model.validate!
    (model.valid?).should be_true
  end

  it "accepts multiple validators" do
    model = MultipleValidatorModel.new
    model.validate!
    (model.valid?).should be_false

    model.status = "win"
    model.name = "dude"
    model.validate!
    (model.valid?).should be_true

    model.works = false
    model.validate!
    (model.valid?).should be_false
  end

  it "accepts inline only" do
    model = InlineOnlyValidatorModel.new
    model.validate!
    (model.valid?).should be_true

    model.awesome = "no"
    model.validate!
    (model.valid?).should be_false
  end

  it "reports back" do
    model = InlineOnlyValidatorModel.new
    model.class.responds_to?(:validators).should be_false

    model = MultipleValidatorModel.new
    model.class.validators.should eq({ StatusFailValidator, NameValidator })
  end
end

describe Accord, "multiple error lists" do
  it "can add them together" do
    list_a = Accord::ErrorList.new
    list_a.add(Accord::Error.new(:name, "is blank"))

    list_b = Accord::ErrorList.new
    list_b.add(Accord::Error.new(:birthday, "doesnt exist"))

    list_c = list_a + list_b
    list_a.size.should eq(1)
    list_b.size.should eq(1)
    list_c.size.should eq(2)
  end
end
