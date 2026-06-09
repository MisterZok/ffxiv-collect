module HairstylesHelper
  def hrothable(hairstyle)
    if hairstyle.hrothable?
      content_tag(:span, "#{fa_icon('paw')} #{fa_icon('mars')}".html_safe, data: { toggle: 'tooltip' },
                  title: t('hairstyles.male_hrothgar'))
    end
  end

  def femhrothable(hairstyle)
    if hairstyle.femhrothable?
      content_tag(:span, "#{fa_icon('paw')} #{fa_icon('venus')}".html_safe, data: { toggle: 'tooltip' },
                  title: t('hairstyles.female_hrothgar'))
    end
  end

  def vierable(hairstyle)
    if hairstyle.vierable?
      content_tag(:span, fa_icon('carrot'), data: { toggle: 'tooltip' }, title: t('hairstyles.viera'))
    end
  end
end
