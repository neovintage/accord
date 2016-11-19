require "./spec_helper"

describe Valcro do
  it "is valid when no validations are defined" do
    test = TestClass.new
    (test.valid?).should eq(true)
    test.errors[:blah].should eq([] of String)
  end
end

describe Valcro, "adding some errors" do
  it "give access to the error list" do
    test = TestClass.new
    test.errors.add(:blah, "blah blah")
    test.errors[:blah].size.should eq(1)
    test.errors[:blah].should eq(["blah blah"])
    (test.valid?).should be_false
  end
end

describe Valcro, "validators" do
  it "can be added" do
    model = StatusModel.new
    model.validate
    (model.valid?).should be_false
  end

  it "clears validations on subsequent runs" do
    model = StatusModel.new
    model.validate
    (model.valid?).should be_false

    model.status = "win"
    model.validate
    (model.valid?).should be_true
  end
end
