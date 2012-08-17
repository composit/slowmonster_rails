require 'spec_helper'

describe 'Routes' do
  specify { { get: 'tasks' }.should route_to controller: 'tasks', action: 'index' }
  specify { { get: 'tasks/1' }.should route_to controller: 'tasks', action: 'show', id: '1' }
  specify { { post: 'tasks' }.should route_to controller: 'tasks', action: 'create' }
  specify { { put: 'tasks/1' }.should route_to controller: 'tasks', action: 'update', id: '1' }
  specify { { delete: 'tasks/1' }.should route_to controller: 'tasks', action: 'destroy', id: '1' }

  specify { { get: 'user_sessions' }.should_not be_routable }
  specify { { get: 'user_sessions/1' }.should_not be_routable }
  specify { { post: 'user_sessions' }.should route_to controller: 'user_sessions', action: 'create' }
  specify { { put: 'user_sessions/1' }.should_not be_routable }
  specify { { delete: 'user_sessions/1' }.should route_to controller: 'user_sessions', action: 'destroy', id: '1' }
end
