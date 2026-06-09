class AddImageUrls < ActiveRecord::Migration[7.2]
  def change
    add_column :achievements, :image_url

    add_column :mounts, :image_url
    add_column :mounts, :large_image_url, :string

    add_column :minions, :image_url, :string
    add_column :minions, :large_image_url, :string

    add_column :hairstyles, :image_url, :string
    add_column :hairstyles, :image_urls, :text

    add_column :emotes, :image_url, :string

    add_column :spells, :image_url, :string

    add_column :bardings, :image_url, :string

    add_column :fashions, :image_url, :string
    add_column :fashions, :large_image_url, :string

    add_column :facewear, :image_url, :string
    add_column :facewear, :image_urls, :text

    add_column :cards, :image_url, :string
    add_column :cards, :large_image_url, :string

    add_column :items, :image_url, :string

    add_column :records, :image_url, :string
    add_column :records, :large_image_url, :string

    add_column :survey_records, :image_url, :string
    add_column :survey_records, :large_image_url, :string

    add_column :occult_records, :image_url, :string
  end
end
