module ArmoiresHelper
  def outfitable(armoire)
    if armoire.outfitable?
      content_tag :span, data: { toggle: 'tooltip', title: t('armoires.outfitable') } do
        collectable_icon('Outfit')
      end
    end
  end
end
