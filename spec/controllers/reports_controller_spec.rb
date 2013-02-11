require 'spec_helper'

describe ReportsController do
  context 'not logged in' do
    it 'redirects to the new user session url' do
      get :show, id: '123'
      expect( response ).to redirect_to new_user_session_url
    end

    it 'displays an alert' do
      get :show, id: '123'
      expect( flash[:alert] ).to eq 'Please sign in'
    end
  end

  context 'logged in' do
    let( :current_user ) { mock_model User }
    let( :current_ability ) { double }

    before do
      controller.stub( :current_user ) { current_user }
      current_ability.extend CanCan::Ability
      controller.stub( :current_ability ) { current_ability }
      current_ability.can :manage, Report
    end

    context 'GET show' do
      render_views

      it 'renders the report totals as json' do
        report = mock_model( Report, unit: 'day' )
        report.stub( chart_values: 'abc' )
        Report.stub( :find ).with( '222' ) { report }
        get 'show', id: 222, format: :json
        expect( response.body ).to eq "{\"report\":{\"chart_values\":\"abc\"}}"
      end
    end
  end
end
