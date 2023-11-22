# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MyEventsController, type: :controller do
  describe 'GET #new' do
    it 'assigns a new event to @event'
    it 'renders the new template'
  end

  describe 'GET #edit' do
    it 'renders the edit template'
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new event'
      it 'redirects to the events index page'
    end

    context 'with invalid attributes' do
      it 'does not save the new event'
      it 're-renders the new template'
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      it 'updates the event'
      it 'redirects to the events index page'
    end

    context 'with invalid attributes' do
      it 'does not update the event'
      it 're-renders the edit template'
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the event'
    it 'redirects to the events index page'
  end
end
