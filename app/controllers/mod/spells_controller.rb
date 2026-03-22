class Mod::SpellsController < Mod::CollectablesController
  def index
    @sprite_key = 'spell'
    super
  end
end
