require "uri"
require "geokit"

module Geokit
  module Geocoders
    class HereGeocoder < Geocoder

      config :app_id, :app_code

      private

      def self.do_geocode(address, options = {})

        if (app_id.nil? || app_id.empty?) || (app_code.nil? || app_code.empty?)
          raise(Geokit::Geocoders::GeocodeError, "Here geocoder API requires auth id and code to use their service.")
        end

        process :xml, submit_url(address)
      end

      def self.submit_url(address)
        args = []
        args << ["app_id", app_id]
        args << ["app_code", app_code]
        args << ["additionaldata", "Country2,1"]
        args << ["language", "en-US"]
        args << ["gen", "9"]

        address_str = address.is_a?(GeoLoc) ? address.to_geocodeable_s : address

        args << ["searchtext", address_str]

        [api_endpoint, '?', URI.encode_www_form(args)].join('')
      end

      def self.api_endpoint
        if ENV['RAKE_ENV'] == 'test'
          "https://geocoder.cit.api.here.com/6.2/geocode.xml"
        else
          "https://geocoder.api.here.com/6.2/geocode.xml"
        end
      end

      XML_MAPPINGS = {
        street_number: "Location/Address/HouseNumber",
        street_name:   "Location/Address/Street",
        province:      "Location/Address/County",
        city:          "Location/Address/City",
        state_name:    "Location/Address/AdditionalData[@key='StateName']",
        state_code:    "Location/Address/State",
        zip:           "Location/Address/PostalCode",
        country_code:  "Location/Address/AdditionalData[@key='Country2']",
        country:       "Location/Address/AdditionalData[@key='CountryName']",
        lat:           "Location/DisplayPosition/Latitude",
        lng:           "Location/DisplayPosition/Longitude",
      }

      def self.parse_xml(xml)
        results = xml.elements.to_a("//Result")
        return GeoLoc.new if results.nil? || results.count == 0
        loc = new_loc
        # only take the first result
        set_mappings(loc, results.first, XML_MAPPINGS)
        loc.success = true
        loc
      end

    end
  end
end