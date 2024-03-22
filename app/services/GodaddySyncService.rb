require 'faraday'
require 'json'

class GodaddySyncService
  #GODADDY_API_ENDPOINT = 'https://api.ote-godaddy.com/v1/domains'
  GODADDY_API_ENDPOINT = 'https://api.godaddy.com/v1/domains'

  def initialize(api_key = ENV['GODADDY_API_KEY'], api_secret = ENV['GODADDY_API_SECRET'])
    @api_key = api_key
    @api_secret = api_secret
  end

  def fetch_domains_from_registrar
    response = connection.get do |req|
      req.url GODADDY_API_ENDPOINT
      req.headers['Authorization'] = "sso-key #{@api_key}:#{@api_secret}"
    end

    puts response.body
    domains = JSON.parse(response.body)
    domains.map do |domain_data|
      Domain.new(
        name: domain_data['domain'],
        registrar_name: 'godaddy',
        registration_date: domain_data['registrarCreatedAt'],
        expiry_date: domain_data['expires'],
      )
    end
  end

  def sync_domains
    domains = fetch_domains_from_registrar
    domains.each do |domain|
      existing_domain = Domain.find_or_initialize_by(name: domain.name)
      existing_domain.update(domain.attributes)
    end
  end

  private

  def connection
    Faraday.new do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end
  end
end