class SugarPNG
  module DynAccessor
    def dyn_accessor *names
      names.each do |name|
        if name.is_a?(Hash)
          # dynamic accessor with alias(es)
          name.each do |main, aliases|
            dyn_accessor main
            Array(aliases).each do |aliased|
              class_eval <<-EOF
                alias :#{aliased}  :#{main}
                alias :#{aliased}= :#{main}=
              EOF
            end
          end
        else
          attr_writer name
          # dynamic getter or setter based on argument given or not
          class_eval <<-EOF
            def #{name} arg=nil
              arg ? @#{name} = arg : @#{name}
            end
          EOF
        end
      end
    end
  end
end
