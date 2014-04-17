require "ruby_selective_inspect/version"

module RubySelectiveInspect
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
    #   player = Player.new(id: 1, name: 'John', health: 100, ip_address: '192.168.1.133')
    #
    #   player.inspect # =>
    #
    #   player.inspect(:name) # =>
    #
    #
    # Returns the String that describes this object and its internals.
    def inspect(*whitelist)
      RubySelectiveInspect.perform_inspect(self, *whitelist)
    end
  end

  # Public: Inspects the given object in a customizable way.
  #
  # target - The Object to be inspected.
  # whitelist - The names of the instance variables to output.
  #
  # Examples
  #
  #   RubySelectiveInspect.inspect(player, :id, :name)
  #   # =>
  #
  # Returns the String that describes the objects and its internals.
  def self.perform_inspect(target, *whitelist)
    klass = target.class
    return target.inspect if !klass.include?(self) && whitelist.size == 0

    whitelist = klass.get_inspectionable_vars if whitelist.size == 0
    if whitelist.size == 0
      whitelist = target.instance_variables.map{ |s| s[1..-1] } - klass.get_uninspectionable_vars
    end

    fields = whitelist.map do |var_name|
      name = '@' + var_name.to_s
      var_content = target.instance_variable_get(name)
      "#{name}=#{var_content.inspect}"
    end

    string = "#<#{klass.name}:#{target.object_id} "
    string + fields.join(", ") + ">"
  end

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
