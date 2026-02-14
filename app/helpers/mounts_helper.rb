module MountsHelper
  def custom_music(mount)
    if mount.custom_music?
      content_tag(:span, fa_icon('music'), title: I18n.t('mounts.custom_music_tooltip'), data: { toggle: 'tooltip', html: true })
    end
  end

  def seat_count(mount, right: true)
    person_count = I18n.t('mounts.person_count', count: mount.seats)
    fa_icon('couch', text: mount.seats, right: right, title: I18n.t('mounts.seats_tooltip', person_count: person_count),
            data: { toggle: 'tooltip' })
  end
end
