# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MyNewsItemsController, type: :controller do
  before do
    User.create!(uid: '12345', provider: 'google_oauth2')
    session[:current_user_id] = 1
    Representative.create!(id: 1)
    @representative = Representative.first
    @news_item = instance_double(NewsItem)
    allow(NewsItem).to receive(:find).and_return(@news_item)
  end

  describe 'GET #new' do
    it 'assigns a new news_item to @news_item' do
      get :new, params: { representative_id: 1 }
      expect(assigns(:news_item)).to be_a_new(NewsItem)
    end

    it 'renders the new template' do
      get :new, params: { representative_id: 1 }
      expect(response).to render_template('new')
    end
  end

  describe 'GET #edit' do
    it 'renders the edit template' do
      get :edit, params: { representative_id: 1, id: 1 }
      expect(response).to render_template('edit')
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before do
        allow(NewsItem).to receive(:new).and_return(@news_item)
        @news_item_params = attributes_for(:news_item)
      end

      it 'creates a new news_item' do
        allow(@news_item).to receive(:save).and_return(true)
        post :create, params: { representative_id: 1, news_item: @news_item_params }
        expect(@news_item).to have_received(:save)
      end

      it 'redirects to the news_items index page' do
        allow(@news_item).to receive(:save).and_return(true)
        post :create, params: { representative_id: 1, news_item: @news_item_params }
        expect(response).to redirect_to(representative_news_item_path(@representative, @news_item))
      end
    end

    context 'with invalid attributes' do
      it 're-renders the new template' do
        allow(@news_item).to receive(:save).and_return(false)
        @news_item_params = attributes_for(:news_item)
        post :create, params: { representative_id: 1, news_item: @news_item_params }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      before do
        @news_item_params = attributes_for(:news_item)
      end

      it 'updates the news_item' do
        allow(@news_item).to receive(:update).and_return(true)
        put :update, params: { representative_id: 1, id: 1, news_item: @news_item_params }
        expect(@news_item).to have_received(:update)
      end

      it 'redirects to the news_items index page' do
        allow(@news_item).to receive(:update).and_return(true)
        put :update, params: { representative_id: 1, id: 1, news_item: @news_item_params }
        expect(response).to redirect_to(representative_news_item_path(@representative, @news_item))
      end
    end

    context 'with invalid attributes' do
      it 're-renders the edit template' do
        allow(@news_item).to receive(:update).and_return(false)
        @news_item_params = attributes_for(:news_item)
        put :update, params: { representative_id: 1, id: 1, news_item: @news_item_params }
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      allow(@news_item).to receive(:destroy).and_return(true)
    end

    it 'deletes the news_item' do
      delete :destroy, params: { representative_id: 1, id: 1 }
      expect(@news_item).to have_received(:destroy)
    end

    it 'redirects to the news_items index page' do
      delete :destroy, params: { representative_id: 1, id: 1 }
      expect(response).to redirect_to(representative_news_items_path(@representative))
    end
  end
end
