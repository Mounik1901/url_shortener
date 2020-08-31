class AddFieldsToShortenUrls < ActiveRecord::Migration[6.0]
  def change
  	add_column :shorten_urls, :countries, :text
  	add_column :shorten_urls, :ips, :text
  	add_column :shorten_urls, :clicks, :integer,  default: 0
  end
end