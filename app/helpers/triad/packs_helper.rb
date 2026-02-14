module Triad::PacksHelper
  def pack_cost(pack)
    pack.cost == 0 ? t('triad.packs.tournament_reward') : "#{number_with_delimiter(pack.cost)} #{t('triad.currency')}"
  end
end
