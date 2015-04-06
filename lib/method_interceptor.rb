require "method_interceptor/version"

module MethodInterceptor

  class Proxy

    instance_methods.each do |m|
      undef_method(m) unless m =~ /(^__|^nil\?$|^send$|^object_id$)/
    end

    def initialize(target, p_transformers={}, r_transformers={})
      @target = target
      @p_transformers = p_transformers
      @r_transformers = r_transformers
    end

    def respond_to?(symbol, include_priv=false)
      @target.respond_to?(symbol, include_priv)
    end

    def method_missing(m, *args, &block)
      params = @target.method(m).parameters.map(&:last)
      t_args = args.dup
      params.each_with_index do |param, ix|
        if @p_transformers[[m, param]] &&
          @p_transformers[[m, param]].kind_of?(Proc)
            t_args[ix] =
              @p_transformers[[m, param]].call(t_args[ix])
        end
      end
      r = @target.send(m, *t_args, &block)
      if @r_transformers[m] &&
        @r_transformers[m].kind_of?(Proc)
          @r_transformers[m].call(r)
      else
        r
      end
    end
  end
end
