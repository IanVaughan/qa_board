require 'spec_helper'

describe Phases do
  let(:phases) { Phases.new }
  let(:default_data) {{:ticket=>'-', :who=>'-'}}

  it "returns default data" do
    test_hash = {}
    Phases::PHASE_TYPES.each {|phase| test_hash[phase] = [default_data]}
    phases.data.should == test_hash
  end

  it "has a default queue size of zero" do
    Phases::PHASE_TYPES.each do |phase_name|
      phases.queue_size(phase_name).should == 0
    end
  end

  context "adding" do
    it "adds a new entry" do
      phases.queue_size(:qa1).should == 0
      phases.add :qa1, 1234, "Bob"
      phases.queue_size(:qa1).should == 1
      phases.data[:qa1].should == [{:ticket=>1234, :who=>"Bob"}]
    end

    it "allows spaces in fields" do
      phases.add(:qa1, "a space", "and here")
      phases.data[:qa1].should == [{:ticket=>"a space", :who=>"and here"}]
    end

    it "adds many new entries" do
      phases.add(:qa1, 1234, "Bob").should == [{:ticket=>1234, :who=>"Bob"}]
      phases.add(:qa1, 6789, "Foo").should == [{:ticket=>1234, :who=>"Bob"}, {:ticket=>6789, :who=>"Foo"}]
      phases.queue_size(:qa1).should == 2
      phases.data[:qa1].should == [{:ticket=>1234, :who=>"Bob"}, {:ticket=>6789, :who=>"Foo"}]
    end

    it "doesnt allow duplicate tickets on the same phase" do
      phases.add(:qa1, 1234, "Bob").should == [{:ticket=>1234, :who=>"Bob"}]
      phases.add(:qa1, 1234, "Foo").should be_false
      phases.queue_size(:qa1).should == 1
    end
  end

  context "deleting" do
    before { phases.add :qa1, 1234, "Bob" }

    it "deletes an item" do
      phases.queue_size(:qa1).should == 1
      phases.delete :qa1, 1234
      phases.queue_size(:qa1).should == 0
      phases.data[:qa1].should == [default_data]
    end

    it "deletes one" do
      phases.add :qa1, 5678, "Bar"
      phases.delete :qa1, 1234
      phases.queue_size(:qa1).should == 1
      phases.data[:qa1].should == [{:ticket=>5678, :who=>"Bar"}]
    end

    it "returns false if none" do
      phases.delete :qa1, 1234 # true
      phases.queue_size(:qa1).should == 0
      phases.data[:qa1].should == [{:ticket=>"-", :who=>"-"}]
      phases.delete :qa1, 1234 # false
      phases.queue_size(:qa1).should == 0
      phases.data[:qa1].should == [{:ticket=>"-", :who=>"-"}]
    end
  end

  context "invalid" do
    it "rejects invalid phase name on add" do
      phases.add(:foo, 5678, "Bar").should be_false # fail
      Phases::PHASE_TYPES.each do |phase_name|
        phases.queue_size(phase_name).should == 0
      end
    end

    it "rejects invalid phase name on count" do
      phases.queue_size(:foo).should be_false
    end
  end

end
