# frozen_string_literal: true

class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all
  
  # avoid existing representative
   validates :name, uniqueness: { scope: [:ocdid, :title] }

  def self.civic_api_to_representative_params(rep_info)
    reps = []
    # rep_info lack required info
    if (not rep_info) or not rep_info.respond_to?(:officials) or not rep_info.respond_to?(:offices)
      return reps
    end
    rep_info.officials.each_with_index do |official, index|
      ocdid_temp = ''
      title_temp = ''

      rep_info.offices.each do |office|
        if office.official_indices.include? index
          title_temp = office.name
          ocdid_temp = office.division_id
        end
      end
      
      # no matched offices
      if ocdid_temp=='' or title_temp==''
        next
      end

      rep = Representative.new({ name: official.name, ocdid: ocdid_temp,
          title: title_temp })
      if rep.save
        reps.push(rep)
      end
    end

    reps
  end
end
