module ImportHelper
  def import_keys_list(keys)
    keys.map { |key| "<code>#{key}</code>"}.join(', ').html_safe
  end
end
