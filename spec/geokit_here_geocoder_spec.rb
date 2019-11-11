require 'spec_helper'

describe Geokit::Geocoders::HereGeocoder do

  context "Geocode address" do

    let(:address) { "Sunnyvale, CA" }

    subject { described_class.geocode(address) }

    context "when missing credentials" do

      before do
        Geokit::Geocoders::HereGeocoder.app_id = nil
        Geokit::Geocoders::HereGeocoder.app_code = nil
      end

      it 'raises an error' do
        expect { subject }.to raise_error Geokit::Geocoders::GeocodeError
      end
    end

    context "with invalid credentials" do

      before do
        Geokit::Geocoders::HereGeocoder.app_id = "test"
        Geokit::Geocoders::HereGeocoder.app_code = "fake"
      end

      it 'returns invalid location' do
        VCR.use_cassette("geocode_permission_denied") do
          expect( subject.success? ).to be false
        end
      end
    end

    context "with correct credentials" do

      before do
        Geokit::Geocoders::HereGeocoder.app_id = ENV['HERE_APP_ID']
        Geokit::Geocoders::HereGeocoder.app_code = ENV['HERE_APP_CODE']
      end

      it 'not raises an error' do
        VCR.use_cassette("geocode_sunnyvale_location") do
          expect { subject }.not_to raise_error
        end
      end

      it 'returns valid location' do
        VCR.use_cassette("geocode_sunnyvale_location") do
          expect( subject.success?     ).to be true
          expect( subject.city         ).to eq "Sunnyvale"
          expect( subject.state_name   ).to eq "California"
          expect( subject.state_code   ).to eq "CA"
          expect( subject.state        ).to eq "CA"
          expect( subject.zip          ).to eq "94086"
          expect( subject.country_code ).to eq "US"
          expect( subject.country      ).to eq "United States"
          expect( subject.lat          ).to eq 37.37172
          expect( subject.lng          ).to eq -122.03801
        end
      end

      context "fake location" do

        let(:address) { "Abcdefg" }

        it 'returns invalid location' do
          VCR.use_cassette("geocode_fake_location") do
            expect( subject.success? ).to be false
          end
        end

      end

    end

  end

  context "Reverse geocode location" do

    let(:latlng) { "37.930530, -122.343580" }

    subject { described_class.reverse_geocode(latlng) }

    context "when missing credentials" do

      before do
        Geokit::Geocoders::HereGeocoder.app_id = nil
        Geokit::Geocoders::HereGeocoder.app_code = nil
      end

      it 'raises an error' do
        expect { subject }.to raise_error Geokit::Geocoders::GeocodeError
      end
    end

    context "with invalid credentials" do

      before do
        Geokit::Geocoders::HereGeocoder.app_id = "test"
        Geokit::Geocoders::HereGeocoder.app_code = "fake"
      end

      it 'returns invalid location' do
        VCR.use_cassette("reverse_geocode_permission_denied") do
          expect( subject.success? ).to be false
        end
      end
    end

    context "with correct credentials" do

      before do
        Geokit::Geocoders::HereGeocoder.app_id = ENV['HERE_APP_ID']
        Geokit::Geocoders::HereGeocoder.app_code = ENV['HERE_APP_CODE']
      end

      it 'not raises an error' do
        VCR.use_cassette("reverse_geocode_richmond_location") do
          expect { subject }.not_to raise_error
        end
      end

      it 'returns valid location' do
        VCR.use_cassette("reverse_geocode_richmond_location") do
          expect( subject.success?     ).to be true
          expect( subject.city         ).to eq "Richmond"
          expect( subject.state_name   ).to eq "California"
          expect( subject.state_code   ).to eq "CA"
          expect( subject.state        ).to eq "CA"
          expect( subject.zip          ).to eq "94804"
          expect( subject.country_code ).to eq "US"
          expect( subject.country      ).to eq "United States"
          expect( subject.lat          ).to eq 37.9305301
          expect( subject.lng          ).to eq -122.3434851
        end
      end

      context "fake location" do

        let(:latlng) { "37.7692014,-122.7737106" }

        it 'returns invalid location' do
          VCR.use_cassette("reverse_geocode_fake_location") do
            expect( subject.success? ).to be false
          end
        end

      end

    end

  end

end
