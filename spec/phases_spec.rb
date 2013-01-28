require 'spec_helper'

describe Phases do
  let(:phases) { Phases.new }
  # subject { Phases.new }
  let(:default_data) {{:ticket=>'-', :who=>'-'}}

  # its(:data) { should == {:qa1=>[], :qa2=>[], :qa3=>[], :qa4=>[], :ready=>[], :staging1=>[], :staging2=>[], :live=>[]} }
  it "returns default data" do
    # phases.data.should == {:qa1=>[], :qa2=>[], :qa3=>[], :qa4=>[], :ready=>[], :staging1=>[], :staging2=>[], :live=>[]}
    phases.data.should == {
      :qa1=>[default_data],
      :qa2=>[default_data],
      :qa3=>[default_data],
      :qa4=>[default_data],
      :ready=>[default_data],
      :staging1=>[default_data],
      :staging2=>[default_data],
      :live=>[default_data]}
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
