require "selective_inspect/version"

module SelectiveInspect
  module ClassMethods
    def inspectionable_vars(*vars)
      @_selective_inspector_whitelist = vars
    end

    def uninspectionable_vars(*vars)
      @_selective_inspector_blacklist = vars
    end

    def get_inspectionable_vars
      @_selective_inspector_whitelist ||= []
    end

    def get_uninspectionable_vars
      @_selective_inspector_blacklist ||= []
    end
  end

  module InstanceMethods
    # Public: Inspects this object in a customizable way.
    #
    # whitelist - (optional) The names of the instance variables to be inspected
    #
    # Examples
    #
    #   Player.new(id: 1, name: 'John', health: 100, ip_address: '192.168.1.133')
    #   # =>
    #
    # Returns the String that describes this object and its internals.
    def inspect(*whitelist)
      SelectiveInspect.perform_inspect(self, *whitelist)
    end
  end

  # Public: Inspects the given object in a customizable way.
  #
  # target - The Object to be inspected.
  # whitelist - The names of the instance variables to output.
  #
  # Examples
  #
  #   SelectiveInspect.inspect(player, :id, :name)
  #   # =>
  #
  # Returns the String that describes the objects and its internals.
  def self.perform_inspect(target, *whitelist)
    klass = target.class
    return target.default_inspect if !klass.include?(self) && whitelist.size == 0


    whitelist = klass.get_inspectionable_vars.map { |name| '@' + name.to_s }
    if whitelist.size == 0
      whitelist = target.instance_variables - klass.get_uninspectionable_vars.map { |name| '@' + name.to_s }
    end

    fields = whitelist.map do |var_name|
      var_content = target.instance_variable_get(var_name)
      "#{var_name}=#{var_content.inspect}"
    end

    string = "#<#{klass.name}:0x#{target.object_id} "
    string + fields.join(", ") + ">"
  end

  # Store a reference to the default implementation
  alias :default_inspect :inspect


  # Add to classes that include this module some convenient class mathods to blacklist
  # or whitelist methods by default.
  def self.included(base_class)
    base_class.class_eval do
      alias_method :default_inspect, :inspect
    end
    base_class.extend ClassMethods
    base_class.include InstanceMethods
  end
end
