namespace :armoires do
  desc 'Create the armoire items'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating armoire items'

    categories = XIVData.sheet('CabinetCategory').filter_map do |category|
      next if category['MenuOrder'] == '0'
      { id: category['#'], name: category['Category'], order: category['MenuOrder'] }
    end

    # The names are actually IDs referencing addon, so we need to look them up
    category_name_ids = categories.map { |category| category[:name] }

    category_names = %w(en de fr ja tc).each_with_object({}) do |locale, h|
      XIVData.sheet('Addon', locale: locale).each do |addon|
        if category_name_ids.include?(addon['#'])
          data = h[addon['#']] || {}
          h[addon['#']] = data.merge("name_#{locale}" => addon['Text'])
        end
      end
    end

    categories.each do |category|
      category.merge!(category_names[category.delete(:name)])

      if existing = ArmoireCategory.find_by(id: category[:id])
        existing.update!(category) if updated?(existing, category)
      else
        ArmoireCategory.create!(category)
      end
    end

    count = Armoire.count

    XIVData.sheet('Cabinet').map do |armoire|
      next if armoire['Order'] == '0'

      item = Item.find_by(id: armoire['Item'])
      next unless item.present?

      data = { id: (armoire['#'].to_i + 1).to_s, category_id: armoire['Category'],
               order: armoire['Order'], order_group: armoire['SubCategory'], item_id: item.id.to_s }

      data[:gender] = case item.description_en
                      when /♂/ then 'male'
                      when /♀/ then 'female'
                      end

      data.merge!(item.slice(:name_en, :name_de, :name_fr, :name_ja, :name_tc,
                             :description_en, :description_de, :description_fr, :description_ja, :description_tc))

      # Update the Item to indicate that it unlocks this Armoire
      item.update!(unlock_type: 'Armoire', unlock_id: data[:id])

      if existing = Armoire.find_by(id: data[:id])
        existing.update!(data) if updated?(existing, data)
      else
        created = Armoire.create!(data)
      end
    end

    puts "Created #{Armoire.count - count} new armoire items"
  end

  task find_outfits: :environment do
    Armoire.where(outfitable: false)
      .joins('INNER JOIN outfit_items ON armoires.item_id = outfit_items.item_id')
      .update_all(outfitable: true)
  end
end
