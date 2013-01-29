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

    it "adds many new entries" do
      phases.add :qa1, 1234, "Bob"
      phases.add :qa1, 6789, "Foo"
      phases.queue_size(:qa1).should == 2
      phases.data[:qa1].should == [{:ticket=>1234, :who=>"Bob"}, {:ticket=>6789, :who=>"Foo"}]
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
  end

  context "invalid" do
    it "rejects invalid phase name" do
      phases.add :foo, 5678, "Bar"
      phases.queue_size(:qa1).should == 0
    end
  end

end
