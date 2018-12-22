require 'pg'
require 'nokogiri'

def main(event:, context:)
  {
    postgres_client_version: PG.library_version,
    nokogiri_version: Nokogiri::VERSION
  }
end
