require 'will_paginate/array'

class Mod::TranslateController < ModController

  def index
    @types = [
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
      { model: Card, label: I18n.t('cards.title'), value: 'Card' },
      { model: Record, label: I18n.t('records.title'), value: 'Record' },
      { model: SurveyRecord, label: I18n.t('survey_records.title'), value: 'SurveyRecord' },
      { model: OccultRecord, label: I18n.t('occult_records.title'), value: 'OccultRecord' },
    ]

    @models = @types.pluck(:model)
    @hidden_types = cookies[:hidden_types_mod_translate]&.split(',')&.map(&:constantize) || []

    @collectables = @models.flat_map do |model|
      @q = model.include_sources.ransack(params[:q])

      collectables = @q.result.ordered
      collectables = collectables.summonable if model == Minion # Exclude variant minions
      collectables = collectables.includes(sources: [:type]) unless @skip_sources

      if model == SurveyRecord
        collectables = collectables.where("solution_#{I18n.locale}" => nil)
      else
        collectables = collectables.joins(:sources).where("sources.text_#{I18n.locale}" => nil)
      end
      collectables
    end

    @collectables = @collectables.paginate(page: params[:page], per_page: 50)
    @changes = PaperTrail::Version.includes(:user).order(id: :desc).paginate(page: params[:page])
  end
end
