[![Build Status](https://travis-ci.org/srozum/here_geocoder.svg?branch=master)](https://travis-ci.org/srozum/here_geocoder)

# HereGeocoder

Custom [geokit](https://github.com/geokit/geokit) geocoder for [Here.com](https://company.here.com/here/) service.

[API Documentation](https://developer.here.com/rest-apis/documentation/geocoder/topics/quick-start.html)


## Installation

Add this line to your application's Gemfile:

    gem 'here_geocoder'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install here_geocoder

## Configuration


```ruby
    # This is your Here application key for the Here Geocoder.
    # See https://developer.here.com/develop/rest-apis
    Geokit::Geocoders::HereGeocoder.app_id = 'REPLACE_WITH_YOUR_KEY'
    Geokit::Geocoders::HereGeocoder.app_code = 'REPLACE_WITH_YOUR_CODE'
```


## Usage

```ruby
    # use :here to specify this geocoder in your list of geocoders.
    Geokit::Geocoders::HereGeocoder.geocode("Sunnyvale, CA")
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/here_geocoder/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
