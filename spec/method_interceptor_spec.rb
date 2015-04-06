require 'spec_helper'

describe MethodInterceptor::Proxy do

  class Tester

    def add_one_to_both(a, b)
      [a+1, b+1]
    end

    def self.add_one_to_both(a, b)
      [a+1, b+1]
    end
  end

  it 'takes given parameter/response transformers and applies whenever matched' do
    parameter_transformers = {
      [:add_one_to_both, :a] => ->(x) { x + 3 },
      [:add_one_to_both, :b] => ->(x) { x - 3 }
    }
    tc = MethodInterceptor::Proxy.new(Tester, parameter_transformers)
    r = tc.add_one_to_both(4, 5)
    expect(r.first).to eq(8)
    expect(r.last).to eq(3)

    t = MethodInterceptor::Proxy.new(Tester.new, parameter_transformers)
    r = t.add_one_to_both(4, 5)
    expect(r.first).to eq(8)
    expect(r.last).to eq(3)

    response_transformers = {
      add_one_to_both: ->(x) { x.map {|i| i * 3} }
    }
    t = MethodInterceptor::Proxy.new(Tester.new,
                                     parameter_transformers,
                                     response_transformers)
    r = t.add_one_to_both(4, 5)
    expect(r.first).to eq(24)
    expect(r.last).to eq(9)
  end
end
