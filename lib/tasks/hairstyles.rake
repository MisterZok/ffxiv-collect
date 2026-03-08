namespace :hairstyles do
  desc 'Create the hairstyles'
  task create: :environment do
    PaperTrail.enabled = false

    puts 'Creating hairstyles'

    count = Hairstyle.count

    XIVData.sheet('CharaMakeCustomize').each_with_object(Set.new) do |custom, created|
      next if custom['HintItem'] == '0'
      item = Item.find_by(id: custom['HintItem'])
      next unless item.present?

      data = { id: custom['UnlockLink'] }

      # Set the Hairstyle name to the item name sans the "Modern Aesthetics"
      data["name_en"] = sanitize_name(item["name_en"], locale: 'en')
        .gsub(/.+-\s(.+)/, '\1')

      data["name_de"] = sanitize_name(item["name_de"], locale: 'de')
        .gsub(/.+„(.+?)“/, '\1') # Quote marks
        .gsub(/.+(?:Ästhetik\s-|,)\s(.+)/, '\1') # Prefixes
        .upcase_first

      data["name_fr"] = sanitize_name(item["name_fr"], locale: 'fr')
        .gsub(/.+“(.+?)”/, '\1') # Hairstyles
        .gsub(/.+:\s(.+)/, '\1') # Facepaint
        .upcase_first

      data["name_ja"] = sanitize_name(item["name_ja"], locale: 'ja')
        .gsub(/.+:(.+)/, '\1')

      data["name_tc"] = sanitize_name(item["name_tc"], locale: 'tc')
        .gsub(/.+：(.+)/, '\1')

      data.merge!(item.slice(:description_en, :description_de, :description_fr, :description_ja, :description_tc))

      data[:item_id] = item.id.to_s

      case item.description_en
      when /♂/ then data[:gender] = 'male'
      when /♀/ then data[:gender] = 'female'
      end

      data[:vierable] = !item.description_en.match(/viera/i)
      data[:femhrothable] = !item.description_en.match(/hrothgar/i) && data[:gender] != 'male'
      data[:hrothable] = !item.description_en.match(/(?<!female )hrothgar/i) && data[:gender] != 'female'

      if existing = Hairstyle.find_by(id: data[:id])
        existing.update!(data) if updated?(existing, data)
      else
        Hairstyle.create!(data)
      end

      # Create the hairstyle images
      path = Rails.root.join('public/images/hairstyles', data[:id])
      Dir.mkdir(path) unless Dir.exist?(path)

      output_path = path.join("#{custom['#']}.png")
      create_image(nil, XIVData.image_path(custom['Icon']), output_path, hd: true)

      # Use the first image as a sample of the hairstyle
      sample_path = Rails.root.join('public/images/hairstyles/samples', "#{data[:id]}.png")

      # Create one sample image the second time we see the style (cuteness guaranteed)
      if !File.exist?(sample_path) && created.include?(item.id)
        FileUtils.cp(output_path, sample_path) unless File.exist?(sample_path)
      end

      created.add(item.id)
    end

    # Create the Eternal Bonding hairstyle which lacks an item unlock
    Hairstyle.find_or_create_by!(id: 228, patch: '2.4', name_en: 'Eternal Bonding', name_de: 'Ewige Bund',
                                 name_fr: 'Lien Éternel', name_ja: 'Eternal Bonding', name_tc: '永恆誓約',
                                 vierable: true, hrothable: true, femhrothable: true)

    # Cache hairstyle image counts in the database
    Hairstyle.all.each do |hairstyle|
      hairstyle.update!(image_count: Dir.glob(Rails.root.join("public/images/hairstyles/#{hairstyle.id}/*.png")).size)
    end

    create_hair_spritesheets

    puts "Created #{Hairstyle.count - count} new hairstyles"
  end
end
