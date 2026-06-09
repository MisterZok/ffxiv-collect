module Triad::CardsHelper
  def type_image(card)
    return if card.card_type_id == 0

    image_tag("cards/#{card.type.name_en.downcase}.png", class: 'card-type')
  end

  def card_number_badge(card)
    content_tag(:span, card.formatted_number, class: 'badge badge-secondary')
  end

  def rarity_options
    (1..5).to_a.reverse.map { |x| ["\u2605" * x, x] }
  end

  def select_tooltip_delay
    '{"show": 500, "hide": 0 }'
  end

  def format_description(card)
    card.description.gsub("\n", '<br>')
      .gsub(/\*(.*?)\*/, '<i>\1</i>')
      .html_safe
  end

  def format_price(price)
    if price > 0
      "#{number_with_delimiter(price)} #{t('triad.currency')}"
    else
      'N/A'
    end
  end
end
