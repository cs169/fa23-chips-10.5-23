# frozen_string_literal: true
require 'open-uri'

class NewsItem < ApplicationRecord
  belongs_to :representative
  has_many :ratings, dependent: :delete_all

  def self.find_for(representative_id)
    NewsItem.find_by(
      representative_id: representative_id
    )
  end

  def self.search_articles(rep_id, issue);
    # Get the representative's name
    rep = Representative.find(rep_id)
    rep_name = rep.name
    rep_name = rep_name.split(' ')
    # rep_name  = rep_name.map { |name| '"' + name + '"' } # Add '"' to name search exact name
    # Join the name
    rep_name = rep_name.join('+')

    # Get the issue
    issue = issue.split(' ')
    # issue = issue.map { |issue| '"' + issue + '"' } # Add '"' to issue search exact issue
    issue = issue.join('+')

    # Get API key
    api_key = Rails.application.credentials[Rails.env.to_sym][:NEWS_API_KEY]


    # Get the articles
    url = "https://newsapi.org/v2/everything?q=#{rep_name}+#{issue}&apiKey=#{api_key}&sortBy=relevancy&language=en"
    response = open(url).read
    response = JSON.parse(response)
    response = response['articles']

    # Return top 5 articles
    response = response[0..4]

    return response
  end
end
