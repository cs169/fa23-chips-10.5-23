# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MyEventsController, type: :controller do
  before do
    User.create!(uid: '12345', provider: 'google_oauth2')
    session[:current_user_id] = 1
    # use instance_double to mock the Event model
    @event = instance_double(Event)
    allow(Event).to receive(:find).and_return(@event)
  end

  describe 'GET #new' do
    it 'assigns a new event to @event' do
      get :new
      expect(assigns(:event)).to be_a_new(Event)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'GET #edit' do
    it 'renders the edit template' do
      get :edit, params: { id: 1 }
      expect(response).to render_template('edit')
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before do
        allow(Event).to receive(:new).and_return(@event)
        @event_params = attributes_for(:event)
      end

      it 'creates a new event' do
        allow(@event).to receive(:save).and_return(true)
        post :create, params: { event: @event_params }
        expect(@event).to have_received(:save)
      end

      it 'redirects to the events index page' do
        allow(@event).to receive(:save).and_return(true)
        post :create, params: { event: @event_params }
        expect(response).to redirect_to(events_path)
      end
    end

    context 'with invalid attributes' do
      it 're-renders the new template' do
        allow(@event).to receive(:save).and_return(false)
        @event_params = attributes_for(:event)
        post :create, params: { event: @event_params }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      before do
        @event_params = attributes_for(:event)
      end

      it 'updates the event' do
        allow(@event).to receive(:update).and_return(true)
        put :update, params: { id: 1, event: @event_params }
        expect(@event).to have_received(:update)
      end

      it 'redirects to the events index page' do
        allow(@event).to receive(:update).and_return(true)
        put :update, params: { id: 1, event: @event_params }
        expect(response).to redirect_to(events_path)
      end
    end

    context 'with invalid attributes' do
      it 're-renders the edit template' do
        allow(@event).to receive(:update).and_return(false)
        @event_params = attributes_for(:event)
        put :update, params: { id: 1, event: @event_params }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      allow(@event).to receive(:destroy).and_return(true)
    end

    it 'deletes the event' do
      delete :destroy, params: { id: 1 }
      expect(@event).to have_received(:destroy)
    end

    it 'redirects to the events index page' do
      delete :destroy, params: { id: 1 }
      expect(response).to redirect_to(events_path)
    end
  end
end
