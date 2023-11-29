# frozen_string_literal: true

class MyNewsItemsController < SessionController
  before_action :set_representative
  before_action :set_representatives_list
  before_action :set_news_item, only: %i[edit update destroy]
  before_action :set_issue_list
  def new
    @news_item = NewsItem.new
  end

  def edit; end

  def create
    @news_item = NewsItem.new(news_item_params)
    if @news_item.save
      redirect_to representative_news_item_path(@representative, @news_item),
                  notice: I18n.t('news_items.created')
    else
      render :new, error: I18n.t('news_items.not_created')
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
    params.require(:news_item).permit(:news, :title, :description, :link, :representative_id, :issue)
  end
end
