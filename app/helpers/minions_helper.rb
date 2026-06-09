module MinionsHelper
  def minion_type(minion)
    image_tag("minions/#{minion.race.name_en.downcase}.png", class: 'minion-type')
  end

  def minion_strength(type, index)
    name = type.parameterize(separator: '_')
    image_tag("minions/#{name}.png", class: 'minion-strength',
              data: { toggle: 'tooltip', title: t('verminion.effective', type: t("verminion.#{name}"))})
  end

  def minion_skill_angle(minion)
    image_tag("minions/angle#{minion.skill_angle}.png", class: 'minion-skill-angle')
  end

  def speed(minion)
    "#{fa_icon('star') * minion.speed}#{fa_icon('star-o') * (4 - minion.speed)}".html_safe
  end

  def speed_options
    (1..4).to_a.reverse.map { |x| ["\u2605" * x, x] }
  end

  def strengths(minion)
    if minion.strengths.values.any?
      strengths = minion.strengths.each_with_index.map do |(type, strong), i|
        if strong
          minion_strength(type, i)
        end
      end

      strengths.join.html_safe
    end
  end

  def strengths_count(minion)
    minion.strengths.values.count(true)
  end

  def strength_options(selected)
    options_for_select([[t('verminion.gates'), 'gate'], [t('verminion.search_eyes'), 'eye'],
                        [t('verminion.shields'), 'shield'], [t('verminion.arcana_stones'), 'arcana']], selected)
  end

  def auto_attack(minion)
    minion.area_attack ? t('verminion.multi_target') : t('verminion.single_target')
  end
end
