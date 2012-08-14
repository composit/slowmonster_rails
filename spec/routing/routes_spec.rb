require 'spec_helper'

describe 'Routes' do
  specify { { get: 'tasks' }.should route_to controller: 'tasks', action: 'index' }
end
