module Support
  module EnvHelper
    extend self

    def stub_env(options, &block)
      ClimateControl.modify(options, &block)
    end
  end
end