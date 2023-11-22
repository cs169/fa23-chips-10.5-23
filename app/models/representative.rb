# frozen_string_literal: true

class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all
  # avoid existing representative
  # validates :name, uniqueness: { scope: %i[ocdid title] }

  def self.check_validation_rep_info(rep_info)
    if !rep_info || !rep_info.respond_to?(:officials) ||
       !rep_info.respond_to?(:offices)
      return false
    end
    return false if rep_info.offices.empty? || rep_info.officials.empty?

    true
  end

  def self.civic_api_to_representative_params(rep_info)
    reps = []
    # rep_info lack required info

    return reps unless check_validation_rep_info(rep_info)

    rep_info.officials.each_with_index do |official, index|
      ocdid_temp = title_temp = ''
      rep_info.offices.each do |office|
        if office.official_indices.include? index
          title_temp = office.name
          ocdid_temp = office.division_id
        end
      end

      rep = Representative.where(name: official.name, ocdid: ocdid_temp, title: title_temp)

      if rep.empty?
        rep = Representative.new({ name: official.name, ocdid: ocdid_temp, title: title_temp })
        rep.save
      else
        rep = rep.first
      end
      reps.push(rep)
    end
    reps
  end
end
