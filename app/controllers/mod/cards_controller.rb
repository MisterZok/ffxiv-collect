class Mod::CardsController < Mod::CollectablesController
  def index
    @sprite_key = 'cards-small'
    super
  end
end
