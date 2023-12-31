# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MyNewsItemsController, type: :controller do
  before do
    User.create!(uid: '12345', provider: 'google_oauth2')
    session[:current_user_id] = 1
    Representative.create!(id: 1, name: 'Biden')
    @representative = Representative.first
    @news_item = instance_double(NewsItem)
    @rating = class_double(Rating)
    allow(NewsItem).to receive(:find).and_return(@news_item)
    allow(@news_item).to receive(:ratings).and_return(@rating)
    allow(@rating).to receive(:where).and_return(@rating)
    allow(@rating).to receive(:first).and_return(@rating)
    allow(@rating).to receive(:update).and_return(true)
  end

  describe 'GET #new' do
    it 'successfully generate a list of representatives name' do
      get :new, params: { representative_id: 1 }
      expect(assigns(:representatives_list)).to eq Representative.pluck(:name)
    end

    it 'renders the new template' do
      get :new, params: { representative_id: 1 }
      expect(response).to render_template('new')
    end
  end

  describe 'POST #search' do
    before do
      @article1 = instance_double(NewsItem)
      @article2 = instance_double(NewsItem)
      allow(NewsItem).to receive(:search_articles).and_return([@article1, @article2])
    end

    it 'calls search_articles with the correct parameters with given params' do
      post :search, params: { representative_id: 1, issue: 'Abortion', representative_name: 'Biden' }
      expect(NewsItem).to have_received(:search_articles).with('Biden', 'Abortion')
    end

    it 'renders the search template' do
      post :search, params: { representative_id: 1, issue: 'Abortion', representative_name: 'Biden' }
      expect(response).to render_template('search')
    end

    it 'render the new view if params miss both issue and representative_name' do
      post :search, params: { representative_id: 1, issue: '', representative_name: '' }
      expect(response).to render_template('new')
      expect(flash[:alert]).to eq 'Search is invalid. Please select one representative and one issue.'
    end

    it 'render the new view if params miss representative_name' do
      post :search, params: { representative_id: 1, issue: 'Abortion', representative_name: '' }
      expect(response).to render_template('new')
      expect(flash[:alert]).to eq 'Search is invalid. Please select one representative from the dropdown menu.'
    end

    it 'render the new view if params miss issue' do
      post :search, params: { representative_id: 1, representative_name: 'Biden', issue: '' }
      expect(response).to render_template('new')
      expect(flash[:alert]).to eq 'Search is invalid. Please select one issue from the dropdown menu.'
    end
  end

  describe 'GET #edit' do
    it 'renders the edit template' do
      get :edit, params: { representative_id: 1, id: 1 }
      expect(response).to render_template('edit')
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      before do
        @news_item_params = attributes_for(:news_item)
        @news_item_params[:ratings] = 1
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

  describe 'POST #create' do
    let(:mock_news_item) { instance_double(NewsItem, save: false) }

    before do
      @news_item_params = attributes_for(:news_item)
    end

    it 'redirect to fail when no parameter' do
      post :create,
params: { representative_id: 1, 'news_item[representative_id]': 1, 'news_item[issue]': 123, rating: 1 }
      expect(response).to render_template(:new)
      expect(flash[:alert]).to eq I18n.t('news_items.need_selection')
    end

    it 'save fail and show alert' do
      allow(controller).to receive(:build_news_item_from_params).and_return(mock_news_item)
      post :create, params: { selected_article_id: 1, representative_id: 1 }
      expect(response).to render_template(:new)
      expect(flash[:alert]).to eq I18n.t('news_items.not_created')
    end

    it 'redirect to representative_news_item_path' do
      allow(@news_item).to receive(:save).and_return(true)
      post :create, params: { selected_article_id: 1, representative_id: 1, 'news_item[article_1_title]': 2,
'news_item[article_1_link]': 1, 'news_item[article_1_description]': 3, 'news_item[representative_id]': 1 }
      expect(response).to redirect_to representative_news_item_path(id: 1)
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
