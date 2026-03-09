module OutfitsHelper
  def armoireable(outfit)
    if outfit.armoireable?
      content_tag :span, data: { toggle: 'tooltip', title: t('outfits.armoireable') } do
        collectable_icon('Armoire')
      end
    end
  end

  def outfit_items(outfit)
    content_tag(:div, class: 'd-flex flex-wrap outfit-items') do
      outfit.items.each do |item|
        concat content_tag(:div, data: { toggle: 'tooltip', title: item.name }) { sprite(item, 'outfit_item') }
      end
    end
  end
end
