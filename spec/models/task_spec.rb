require 'spec_helper'

describe Task do
  it 'is valid' do
    build( :task ).should be_valid
  end

  it 'persists content' do
    task = create :task, content: 'this is a test'
    task.reload.content.should == 'this is a test'
  end

  context 'requires content' do
    let( :task ) { build :task, content: nil }

    specify { task.should_not be_valid }
    specify { task.valid?; task.errors.full_messages.should == ['Content can\'t be blank'] }
  end
end
