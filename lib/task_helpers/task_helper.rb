# frozen_string_literal: true

require 'json'
require 'zip'

module TaskHelper
  # Delete and recreate the given Rails.root relative dir_name.
  def self.reinit_dir(dir_name)
    Rails.logger.info "Deleting and recreating folder: #{dir_name}"
    FileUtils.rm_rf(Rails.root.join(dir_name)) &&
      FileUtils.mkdir_p(Rails.root.join(dir_name))
  end

  # Extract the given Rails.root relative zip_file into the Rails.root relative dest_folder.
  def self.extract_zip(zip_file, dest_folder)
    Zip::File.open(Rails.root.join(zip_file)) do |f|
      f.each do |zipped_file|
        f.extract(
          zipped_file,
          Rails.root.join(dest_folder, zipped_file.name)
        )
      end
    end
  end

  # Writes content to the given Rails.root relative filename.
  def self.write_json(filename, content)
    Rails.root.join(filename).open('w:UTF-8') do |f|
      f.write(
        JSON.pretty_generate(content)
              .force_encoding('UTF-8')
      )
    end
  end
end
