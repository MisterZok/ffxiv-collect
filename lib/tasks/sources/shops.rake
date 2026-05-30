namespace 'sources:shops' do
  desc 'Create shop sources'
  task update: :environment do
    PaperTrail.enabled = false

    include ActionView::Helpers::NumberHelper

    cosmic_exploration_type = SourceType.find_by(name_en: 'Cosmic Exploration')
    crafting_type = SourceType.find_by(name_en: 'Crafting')
    fate_type = SourceType.find_by(name_en: 'FATE')
    gathering_type = SourceType.find_by(name_en: 'Gathering')
    gold_saucer_type = SourceType.find_by(name_en: 'Gold Saucer')
    hunts_type = SourceType.find_by(name_en: 'Hunts')
    island_sanctuary_type = SourceType.find_by(name_en: 'Island Sanctuary')
    occult_crescent_type = SourceType.find_by(name_en: 'Occult Crescent')
    purchase_type = SourceType.find_by(name_en: 'Purchase')
    pvp_type = SourceType.find_by(name_en: 'PvP')
    skybuilders_type = SourceType.find_by(name_en: 'Skybuilders')
    vc_dungeon_type = SourceType.find_by(name_en: 'V&C Dungeon')
    wondrous_tails_type = SourceType.find_by(name_en: 'Wondrous Tails')

    # Avoid creating sources from limited time shops, most enhancement shops or specific NPCs
    restricted_special_shop_names = /(seasonal event prizes|augmentation|reoutfitting|artifact gear repair)/i
    restricted_vendor_names = /(calamity salvager|journeyman salvager|recompense officer)/i

    puts 'Fetching restricted vendors data'

    topics = XIVData.sheet('TopicSelect').each_with_object({}) do |topic, h|
      h[topic['#']] = Set.new

      10.times do |i|
        break if topic["Shop[#{i}]"] == '0'

        h[topic['#']].add(topic["Shop[#{i}]"])
      end
    end

    restricted_npc_ids = XIVData.sheet('ENpcResident', locale: 'en').filter_map do |npc|
      next unless npc['Singular'].present? && npc['Singular'].match?(restricted_vendor_names)

      npc['#']
    end

    restricted_shop_ids = Set.new
    XIVData.sheet('ENpcBase').each do |npc|
      next unless restricted_npc_ids.include?(npc['#'])

      32.times do |i|
        id = npc["ENpcData[#{i}]"]
        break if id == '0'

        # Only store IDs from GilShop or SpecialShop
        case id
        when /^(26|17[67])\d{4}$/ # GilShop / SpecialShop
          restricted_shop_ids.add(id)
        when /^3276\d{3}$/ # Shops from TopicSelect
          if topics[id].present?
            restricted_shop_ids.merge(topics[id])
          end
        else
          next
        end
      end
    end

    puts 'Creating GilShop sources'

    restricted_gil_shops = XIVData.sheet('GilShop').filter_map do |shop|
      next unless shop['FestivalId'] != '0' || restricted_shop_ids.include?(shop['#'])

      shop['#']
    end

    item_ids = XIVData.sheet('GilShopItem').filter_map do |entry|
      next if restricted_gil_shops.include?(entry['#'].split('.').first)

      entry['Item']
    end

    gil = Item.find_by(name_en: 'Gil')

    Item.where.not(unlock_id: nil).where.not(price: 0).where(id: item_ids).each do |item|
      texts = currency_texts(item.price, gil)
      create_shop_source(item.unlock, purchase_type, texts)
    end

    puts 'Creating SpecialShop sources'

    item_ids = Item.where.not(unlock_id: nil).pluck(:id).map(&:to_s)

    outfit_item_ids = OutfitItem.pluck(:item_id).uniq.map(&:to_s)
    outfit_items = {}

    tomestone_items = XIVData.sheet('TomestonesItem').each_with_object({}) do |tomestone, h|
      next if tomestone['Tomestones'] == '0'

      h[tomestone['Tomestones'].to_i] = Item.find(tomestone['Item'])
    end

    XIVData.sheet('SpecialShop').each do |shop|
      next if shop["RequiredFestival"] != '0' ||
        shop['Name']&.match?(restricted_special_shop_names) ||
        restricted_shop_ids.include?(shop['#'])

      60.times do |i|
        item_id = shop["Item[#{i}].Item[0]"] # We only need the first item
        break if item_id == '0'

        next unless item_ids.include?(item_id) || outfit_item_ids.include?(item_id)

        source_to_create = {}

        3.times do |j|
          price = shop["Item[#{i}].CurrencyCost[#{j}]"]
          next if price == '0'

          currency_item_id = shop["Item[#{i}].ItemCost[#{j}]"].to_i
          type = case currency_item_id
          when 25, 36656, 40479
            pvp_type
          when 27, 10307, 26533
            hunts_type
          when 29, 41629
            gold_saucer_type
          when 26807
            fate_type
          when 28063
            skybuilders_type
          when 30341
            wondrous_tails_type
          when 37549
            island_sanctuary_type
          when 38533, 39884, 41078, 50434
            vc_dungeon_type
          when 45043, 45044, 47868
            occult_crescent_type
          when 45690
            cosmic_exploration_type
          else
            purchase_type
          end

          currency = case shop["Item[#{i}].CostType[#{j}]"].to_i
          when 0, 1
            Item.find(currency_item_id)
          when 2
            tomestone_items[currency_item_id]
          when 3
            scrip_id = case currency_item_id
            when 1
              type = crafting_type
              25199 # White Crafters' Scrip
            when 2
              type = crafting_type
              33913 # Purple Crafters' Scrip
            when 3
              type = gathering_type
              25200 # White Gatherers' Scrip
            when 4
              type = gathering_type
              33914 # Purple Gatherers' Scrip
            when 5
              type = hunts_type
              10307 # Centurio Seal
            when 6
              type = crafting_type
              41784 # Orange Crafters' Scrip
            when 7
              type = gathering_type
              41785 # Orange Gatherers' Scrip
            end

            Item.find(scrip_id)
          else
            next # Skip currencies that cannot be resolved to items
          end

          # Do not create shop sources for Moogle Treasure Trove rewards
          next if currency['name_en'].match?('Irregular Tomestone')

          # Add collectable source data
          if item_ids.include?(item_id)
            if source_to_create.present?
              texts = join_source_texts(source_to_create[:texts], currency_texts(price, currency))
              source_to_create.merge!({ texts: texts })
            else
              source_to_create = { item_id: item_id, type: type, texts: currency_texts(price, currency) }
            end
          end

          # Add outfit source data
          if outfit_item_ids.include?(item_id)
            outfit_items[item_id] = { price: price.to_i, currency: currency, type: type }
          end
        end

        # Create source based on fetched data
        if source_to_create.present?
          type, texts = source_to_create.values_at(:type, :texts)
          create_shop_source(Item.find(item_id).unlock, type, texts)
        end
      end
    end

    # Create outfit sources based on the final data
    Outfit.all.each do |outfit|
      prices = outfit.item_ids.map do |item_id|
        outfit_items[item_id.to_s]&.dig(:price)
      end

      # Skip creating the source unless all items are priced
      next unless prices.all?

      price = prices.sum
      next if price == 0

      currency, type = outfit_items[outfit.item_ids.first.to_s].values_at(:currency, :type)
      texts = currency_texts(price, currency)

      create_shop_source(outfit, type, texts)
    end

    puts 'Creating Grand Company sources'
    XIVData.sheet('GCScripShopItem').each do |entry|
      next unless item_ids.include?(entry['Item'])

      unlock = Item.find(entry['Item']).unlock

      texts = %w(en de fr ja tc).each_with_object({}) do |locale, h|
        amount = number_with_delimiter(entry['CostGCSeals'], locale: locale)
        h["text_#{locale}"] = I18n.t('sources.seals', amount: amount, locale: locale)
      end

      create_shop_source(unlock, purchase_type, texts)
    end
  end
end

private
# Create shop sources for collectables with no known sources.
def create_shop_source(unlock, type, texts)
  unless unlock.sources.any?
    unlock.sources.create!(**texts, type: type)
  end
end

def currency_texts(price, currency)
  %w(en de fr ja tc).each_with_object({}) do |locale, h|
    if price != '1' && currency["plural_#{locale}"].present?
      formatted_currency = currency["plural_#{locale}"]
    else
      formatted_currency = currency["name_#{locale}"]
    end

    next unless formatted_currency.present?

    formatted_price = number_with_delimiter(price, locale: locale)
    h["text_#{locale}"] = "#{formatted_price} #{formatted_currency}"
  end
end

def join_source_texts(old_hash, new_hash)
  old_hash.merge(new_hash) { |key, old_value, new_value| [old_value, new_value].join(' + ') }
end
