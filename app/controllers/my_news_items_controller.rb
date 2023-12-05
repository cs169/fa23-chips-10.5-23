# frozen_string_literal: true

class MyNewsItemsController < SessionController
  before_action :set_representative
  before_action :set_representatives_list
  before_action :set_news_item, only: %i[edit update destroy]
  before_action :set_issue_list
  def new
    @representatives_list = Representative.pluck(:name)
  end

  def search
    @rep_name = params[:representative_name]
    @issue = params[:issue]
    @rep_id = Representative.where(name: @rep_name).first.id
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
    @articles = NewsItem.search_articles(@rep_name, @issue)

    @article1 = NewsItem.new
    @article2 = NewsItem.new
    @article3 = NewsItem.new
    @article4 = NewsItem.new
    @article5 = NewsItem.new

    @article1.id=1
    @article1.title='Title1'
    @article1.link='https://baidu.com'
    @article1.description='This is an article'

    @article2.id=2
    @article2.title='Title2'
    @article2.link='https://google.com'
    @article2.description='This is another article'

    @article3.id=3
    @article3.title='Title3'
    @article3.link='https://google.com'
    @article3.description='This is another article'

    @article4.id=4
    @article4.title='Title4'
    @article4.link='https://google.com'
    @article4.description='This is another article'

    @article5.id=5
    @article5.title='Title5'
    @article5.link='https://google.com'
    @article5.description='This is another article'
    @articles= [
      @article1, @article2, @article3, @article4, @article5
    ]
  end

  def edit; end

  def create
    selected_article_id = params[:selected_article_id]
    if selected_article_id.nil?
      flash.now[:alert] = I18n.t('news_items.need_selection')
      render :new
      return
    end
    selected_article_title = params[:news_item]["article_#{selected_article_id}_title"]
    selected_article_link = params[:news_item]["article_#{selected_article_id}_link"]
    selected_article_description = params[:news_item]["article_#{selected_article_id}_description"]

    @news_item = NewsItem.new(news_item_params)
    @news_item.title = selected_article_title
    @news_item.link = selected_article_link
    @news_item.description = selected_article_description

    @rating = Rating.new(user_id: session[:current_user_id], news_item_id: selected_article_id, score: params[:rating])
    if @news_item.save && @rating.save
      redirect_to representative_news_item_path(@representative, @news_item),
        notice: I18n.t('news_items.created')
    else
      flash.now[:alert] = I18n.t('news_items.not_created')
      render :new
    end
  end

  def update
    if @news_item.update(news_item_params)
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
    @representatives_list = Representative.all.map { |r| [r.name, r.id] }
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
                                      :representative_name)
  end
end
