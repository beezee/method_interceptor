# ParameterTransformers

This gem provides a proxy which can encapsulate transformers to be
applied to given method/parameter combinations before the target
method is called or method response after it is called.

It is useful for scenarios where you might have a stateful value that
needs to be consistently applied to other parameters being passed to
library code.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'parameter_transformers'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install parameter_transformers

## Usage

Here's an example of using the proxy to consistently apply an authentication header to all requests made with the RestClient gem and parse responses as JSON:

```ruby
require 'rest_client'
require 'parameter_transformers'
require 'json'

add_auth_header = ->(headers) { (headers || {}).merge('AUTH-HEADER' => 'key') }
p_transformers = [:get, :post, :put, :delete].map do |method|
  [[method, :headers], add_auth_header]
end
r_transformers = [:get, :post, :put, :delete].map do |method|
  [method, JSON.method(:parse)]
end
rc = ParameterTransformers::Proxy.new(RestClient, Hash[p_transformers], Hash[r_transformers])

# automatically adds {'AUTH-HEADER' => 'key'} to headers on all calls now
# and automatically parses responses as json
rc.get('http://somesite.com')
rc.post('http://somesite.com', {foo: 'bar'})
rc.put('http://somesite.com', {foo: 'bar'})
rc.delete('http://somesite.com')
```

Note per example above the format for transformers is a hash where
keys are an array of [:method_name, :argument_name] and values
are procs which receive a copy of the passed argument, and return the
transformed value to be passed to the method on the target object

Meanwhile for the response transformers, the format is a hash where
keys are the method name, and values are procs which receive the actual
response

## Contributing

1. Fork it ( https://github.com/[my-github-username]/parameter_transformers/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
