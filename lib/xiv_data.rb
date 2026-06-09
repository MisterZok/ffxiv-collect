require 'csv'

module XIVData
  extend self

  BASE_PATH = Rails.root.join('vendor/xiv-data/exd').freeze
  BASE_URL = 'https://v2.xivapi.com/api/asset'.freeze
  USER_AGENT = "FFXIVCollect".freeze

  def sheet(sheet, locale: nil)
    if locale.present?
      path = "#{BASE_PATH}/#{locale}/#{sheet}.csv"
    else
      path = "#{BASE_PATH}/en/#{sheet}.csv"
    end

    data = File.read(path)
    CSV.parse(data, headers: true)
  end

  def format_icon_id(icon_id)
    icon_id.to_s.rjust(6, '0')
  end

  def image_path(icon_id, hd: false)
    number = format_icon_id(icon_id)
    directory = number.first(3).ljust(6, '0')
    "ui/icon/#{directory}/#{number}#{'_hr1' if hd}.tex"
  end

  def image_url(icon_id)
    query = { path: image_path(icon_id, hd: true), format: 'webp' }.to_query
    "#{BASE_URL}?#{query}"
  end

  def download_image(path, format: 'png')
    params = { path: path, format: format }

    RestClient::Request.execute(
      method: :get,
      url: BASE_URL,
      headers: { params: params, user_agent: USER_AGENT },
      raw_response: true
    )
  end
end
