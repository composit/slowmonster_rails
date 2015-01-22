require 'spec_helper'

describe 'Routes' do
  specify { expect( post: 'task_times' ).to route_to controller: 'task_times', action: 'create' }
  specify { expect( put: 'task_times/1/stop' ).to route_to controller: 'task_times', action: 'stop', id: '1' }
  specify { expect( get: 'tasks' ).to route_to controller: 'tasks', action: 'index' }
  specify { expect( get: 'tasks/1' ).to route_to controller: 'tasks', action: 'show', id: '1' }
  specify { expect( post: 'tasks' ).to route_to controller: 'tasks', action: 'create' }
  specify { expect( put: 'tasks/1' ).to route_to controller: 'tasks', action: 'update', id: '1' }
  specify { expect( delete: 'tasks/1' ).to route_to controller: 'tasks', action: 'destroy', id: '1' }
  specify { expect( put: 'tasks/reprioritize' ).to route_to controller: 'tasks', action: 'reprioritize' }
  specify { expect( put: 'tasks/1/close' ).to route_to controller: 'tasks', action: 'close', id: '1' }
  specify { expect(put: 'tasks/1/add_amount').to route_to controller: 'tasks', action: 'add_amount', id: '1' }

  specify { expect( get: 'user_session' ).to_not be_routable }
  specify { expect( get: 'user_session/1' ).to_not be_routable }
  specify { expect( post: 'user_session' ).to route_to controller: 'user_sessions', action: 'create' }
  specify { expect( put: 'user_session/1' ).to_not be_routable }
  specify { expect( delete: 'user_session' ).to route_to controller: 'user_sessions', action: 'destroy' }

  specify { expect( get: 'users' ).to_not be_routable }
  specify { expect( get: 'users/1' ).to route_to controller: 'users', action: 'show', id: '1' }
  specify { expect( post: 'users' ).to_not be_routable }
  specify { expect( put: 'users/1' ).to_not be_routable }
  specify { expect( delete: 'users/1' ).to_not be_routable }
  specify { expect( get: 'users/current_task_time' ).to route_to controller: 'users', action: 'current_task_time' }

  specify { expect( get: 'task_joiners' ).to_not be_routable }
  specify { expect( get: 'task_joiners/1' ).to_not be_routable }
  specify { expect( post: 'task_joiners' ).to route_to controller: 'task_joiners', action: 'create' }
  specify { expect( put: 'task_joiners/1' ).to_not be_routable }
  specify { expect( delete: 'task_joiners/1' ).to route_to controller: 'task_joiners', action: 'destroy', id: '1' }

  specify { expect( get: 'reports/1' ).to route_to controller: 'reports', action: 'show', id: '1' }
end
