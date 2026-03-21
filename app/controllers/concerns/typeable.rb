module Typeable
  extend ActiveSupport::Concern

  def collectable_types(with_records: false)
    types = [
      { model: Mount, label: I18n.t('mounts.title'), value: 'Mount' },
      { model: Minion, label: I18n.t('minions.title'), value: 'Minion' },
      { model: Hairstyle, label: I18n.t('hairstyles.title'), value: 'Hairstyle' },
      { model: Emote, label: I18n.t('emotes.title'), value: 'Emote' },
      { model: Orchestrion, label: I18n.t('orchestrions.title'), value: 'Orchestrion' },
      { model: Frame, label: I18n.t('frames.title'), value: 'Frame' },
      { model: Spell, label: I18n.t('spells.title'), value: 'Spell' },
      { model: Barding, label: I18n.t('bardings.title'), value: 'Barding' },
      { model: Fashion, label: I18n.t('fashions.title'), value: 'Fashion' },
      { model: Facewear, label: I18n.t('facewear.title'), value: 'Facewear' },
      { model: Outfit, label: I18n.t('outfits.title'), value: 'Outfit' },
      { model: Armoire, label: I18n.t('armoires.title'), value: 'Armoire' },
      { model: Card, label: I18n.t('cards.title'), value: 'Card' }
    ]

    if with_records
      types += [
        { model: Record, label: I18n.t('records.title'), value: 'Record' },
        { model: SurveyRecord, label: I18n.t('survey_records.title'), value: 'SurveyRecord' },
        { model: OccultRecord, label: I18n.t('occult_records.title'), value: 'OccultRecord' }
      ]
    end

    types
  end
end
