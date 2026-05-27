namespace 'sources:armoires' do
  desc 'Create initial Armoire sources based on sub categories'
  task update: :environment do
    PaperTrail.enabled = false

    puts 'Creating Armoire sources'

    DUNGEON_TYPE = SourceType.find_by(name_en: 'Dungeon').freeze
    PREMIUM_TYPE = SourceType.find_by(name_en: 'Premium').freeze

    ARMOIRE_DUNGEON_CATEGORY = ArmoireCategory.find_by(name_en: 'Dungeon Gear').freeze
    PREMIUM_CATEGORIES = ArmoireCategory.where(name_en: %w(Costumes Fashions Mascots)).pluck(:id).freeze

    sub_categories = XIVData.sheet('CabinetSubCategory').each_with_object({}) do |sub_category, h|
      next unless sub_category['Name'].present?

      h[sub_category['#'].to_i] = sub_category['Name']
    end

    Armoire.all.each do |armoire|
      next if armoire.sources.any?

      # Automatically create Dungeon and Premium sources
      if armoire['category_id'] == ARMOIRE_DUNGEON_CATEGORY['id']
        related = Instance.find_by(name_en: sub_categories[armoire["order_group"]])

        next unless related.present?

        texts = %w(en de fr ja tc).each_with_object({}) do |locale, h|
          h["text_#{locale}"] = related["name_#{locale}"]
        end

        armoire.sources.create!(**texts, type: DUNGEON_TYPE, related_type: 'Instance', related_id: related&.id)
      elsif PREMIUM_CATEGORIES.include?(armoire['category_id'])
        texts = %w(en de fr ja tc).each_with_object({}) do |locale, h|
          h["text_#{locale}"] = I18n.t('sources.online_store', locale: locale)
        end

        armoire.sources.create!(**texts, type: PREMIUM_TYPE, premium: true)
      end
    end
  end
end
