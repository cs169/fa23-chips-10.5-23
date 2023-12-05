# frozen_string_literal: true

class MyNewsItemsController < SessionController
  before_action :set_representative
  before_action :set_representatives_list
  before_action :set_representatives_list_with_id
  before_action :set_news_item, only: %i[edit update destroy]
  before_action :set_issue_list
  def new; end

  def search
    @rep_name = params[:representative_name]
    @issue = params[:issue]
    if (@rep_name == '') && (@issue == '')
      flash.now[:alert] = I18n.t('news_items.neither_search')
      render :new
      return
    elsif @rep_name == ''
      flash.now[:alert] = I18n.t('news_items.no_rep_search')
      render :new
      return
    elsif @issue == ''
      flash.now[:alert] = I18n.t('news_items.no_issue_search')
      render :new
      return
    end
    @rep_id = Representative.where(name: @rep_name).first.id
    @articles = NewsItem.search_articles(@rep_name, @issue)
  end

  def edit; end

  def create
    selected_article_id = params[:selected_article_id]
    if selected_article_id.nil?
      flash.now[:alert] = I18n.t('news_items.need_selection')
      render :new
      return
    end
    @news_item = build_news_item_from_params
    if @news_item.save
      @rating = Rating.new(user_id: session[:current_user_id], news_item_id: @news_item.id, score: params[:rating])
      @rating.save
      redirect_to representative_news_item_path(@representative, @news_item), notice: I18n.t('news_items.created')
    else
      flash.now[:alert] = I18n.t('news_items.not_created')
      render :new
    end
  end

  def update
    user_id = session[:current_user_id]
    rating = @news_item.ratings.where(user_id: user_id).first
    rating.update(score: news_item_params[:ratings])
    news_item_update_params = news_item_params
    news_item_update_params.delete(:ratings)
    if @news_item.update(news_item_update_params)
      redirect_to representative_news_item_path(@representative, @news_item),
        notice: I18n.t('news_items.updated')
    else
      render :edit, error: I18n.t('news_items.not_updated')
    end
  end

  def destroy
    @news_item.destroy
    redirect_to representative_news_items_path(@representative),
      notice: I18n.t('news_items.destroyed')
  end

  private

  def set_representative
    @representative = Representative.find(
      params[:representative_id]
    )
  end

  def set_representatives_list
    @representatives_list = Representative.all.map(&:name)
  end

  def set_representatives_list_with_id
    @representatives_list_with_id = Representative.all.map { |r| [r.name, r.id] }
  end

  def build_news_item_from_params
    selected_article_id = params[:selected_article_id]
    @news_item = NewsItem.new(news_item_params)
    @news_item.title = params[:news_item]["article_#{selected_article_id}_title"]
    @news_item.link = params[:news_item]["article_#{selected_article_id}_link"]
    @news_item.description = params[:news_item]["article_#{selected_article_id}_description"]
    @news_item
  end

  def set_news_item
    @news_item = NewsItem.find(params[:id])
  end

  def set_issue_list
    @issue_list = ['Free Speech', 'Immigration', 'Terrorism', "Social Security and
Medicare", 'Abortion', 'Student Loans', 'Gun Control', 'Unemployment',
                   'Climate Change', 'Homelessness', 'Racism', 'Tax Reform', "Net
Neutrality", 'Religious Freedom', 'Border Security', 'Minimum Wage',
                   'Equal Pay'].map { |r| [r, r] }
  end

  # Only allow a list of trusted parameters through.
  def news_item_params
    params.require(:news_item).permit(:news, :title, :description, :link, :representative_id, :issue,
                                      :representative_name, :ratings)
  end
end
