require 'spec_helper'

describe Phases do
  let(:phases) { Phases.new }
  # let(:default_data) {{:ticket=>'-', :who=>'-'}}

  it "returns default data" do
    test_hash = {}
    Phases::PHASE_TYPES.each {|phase| test_hash[phase] = []}
    # phases.class.to_json.should == Hash
    phases.should == test_hash
  end

  it "has a default queue size of zero" do
    Phases::PHASE_TYPES.each do |phase_name|
      phases[phase_name].size.should == 0
    end
  end

  it "has a queue" do
    phase_name = :qa1
    phases[phase_name].size.should == 0
    phases[phase_name].should == []
  end

  context "adding" do
    it "adds a new entry" do
      phases[:qa1].size.should == 0
      phases.add(:qa1, 1234, "Bob")
      phases.add(:qa1, 1234, "Bob")
      phases[:qa1].size.should == 1
      phases.size(:qa1).should == 1
      phases[:qa1].should == [{:ticket=>1234, :who=>"Bob"}]
    end

    # it "adds via =" do
    #   phases[:qa1] = {:ticket=>1234, :who=>"Bob"}
    #   phases[:qa1].size.should == 1
    #   phases[:qa1].should == [{:ticket=>1234, :who=>"Bob"}]
    # end
    # it "adds via =" do
    #   phases[:qa1].add(:ticket=>1234, :who=>"Bob")
    #   phases[:qa1].size.should == 1
    #   phases[:qa1].should == [{:ticket=>1234, :who=>"Bob"}]
    # end

    it "allows spaces in fields" do
      phases.add(:qa1, "a space", "and here")
      phases[:qa1].should == [{:ticket=>"a space", :who=>"and here"}]
    end

    it "adds many new entries" do
      phases.add(:qa1, 1234, "Bob").should == [{:ticket=>1234, :who=>"Bob"}]
      phases.add(:qa1, 6789, "Foo").should == [{:ticket=>1234, :who=>"Bob"}, {:ticket=>6789, :who=>"Foo"}]
      phases[:qa1].size.should == 2
      phases[:qa1].should == [{:ticket=>1234, :who=>"Bob"}, {:ticket=>6789, :who=>"Foo"}]
    end

    it "doesnt allow duplicate tickets on the same phase" do
      phases.add(:qa1, 1234, "Bob").should == [{:ticket=>1234, :who=>"Bob"}]
      phases.add(:qa1, 1234, "Foo").should be_false
      phases[:qa1].size.should == 1
    end

    it "allows same tickets on different phases" do
      phases.add(:qa1, 1234, "Bob")
      phases.add(:qa2, 1234, "Bob")
      phases[:qa1].size.should == 1
      phases[:qa2].size.should == 1
    end
  end

  context "deleting" do
    before { phases.add :qa1, 1234, "Bob" }

    it "deletes an item" do
      phases[:qa1].size.should == 1
      phases.delete :qa1, 1234
      phases[:qa1].size.should == 0
      phases[:qa1].should == []
    end

    it "deletes one" do
      phases.add :qa1, 5678, "Bar"
      phases.delete :qa1, 1234
      phases[:qa1].size.should == 1
      phases[:qa1].should == [{:ticket=>5678, :who=>"Bar"}]
    end

    it "returns false if none" do
      phases.delete :qa1, 1234 # true
      phases[:qa1].size.should == 0
      phases[:qa1].should == [] # [{:ticket=>"-", :who=>"-"}]
      phases.delete :qa1, 1234 # false
      phases[:qa1].size.should == 0
      phases[:qa1].should == [] # [{:ticket=>"-", :who=>"-"}]
    end
  end

  context "invalid" do
    it "rejects invalid phase name" do
      phases.add(:foo, 5678, "Bar").should be_false # fail
      # phases[:foo].size.should be_nil
      phases[:foo].should be_nil

      Phases::PHASE_TYPES.each do |phase_name|
        # phases[phase_name].size.should == 0
        phases[phase_name].should == [] # be_nil
      end
    end
  end

  context "valid?" do
    if "returns a hash with what was missing"
      Phases.valid?().should == {missing: [:phase, :ticket]}
      Phases.valid?({}).should == {missing: [:phase, :ticket]}
      Phases.valid?({'phase' => "QA1"}).should == {missing: [:ticket]}
      # Phases.valid?({'phase' => "QA1", 'ticket' => nil}).should == {:invalid=>:ticket, :data=>nil}
      # Phases.valid?({'phase' => "foo", 'ticket' => 1}).should == {:invalid=>:phase, :data=>"QA1"}
      # Phases.valid?({'phase' => "QA1", 'ticket' => 1}).should == {}
      # Phases.valid?({'ticket' => 1}).should == {:invalid=>:ticket, :data=>nil}
    end
  end

end
