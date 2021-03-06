Puppet::Type.newtype(:f5_virtualserver) do
  @doc = "Manages F5 virtualservers."

  apply_to_device

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, :namevar=>true) do
    desc "The virtualserver name."

    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Virtualserver names must be a fully qualified path, not '#{value}'"
      end
    end
  end

  newproperty(:description) do
    desc "The virtualserver description"
  end

  newproperty(:address) do
    desc "The virtualserver address"
  end

  newproperty(:default_pool) do
    desc "The virtualserver default pool"
  end

  newproperty(:port) do
    desc "The virtualserver port"

    munge do |value|
      begin
        Integer(value)
      rescue
        fail Puppet::Error, "Parameter 'port' must be a number, not '#{value}'"
      end
    end
  end

  newproperty(:fallback_persistence_profile) do
    desc "The virtualserver fallback persistence profile"
  end

  newproperty(:persistence_profile) do
    desc "The virtualserver default persistence profile"
  end

  newproperty(:protocol) do
    desc "The virtualserver default persistence profile"

    def should=(values)
      super(values.upcase)
    end

    validate do |value|
      valid_protocols =
        ["ANY", "IPV6", "ROUTING", "NONE", "FRAGMENT", "DSTOPTS", "TCP", "UDP", "ICMP", "ICMPV6",
         "OSPF", "SCTP", "UNKNOWN"]

      unless valid_protocols.include?(value.upcase)
        fail Puppet::Error, "Parameter '#{self.name}' must be one of:"\
        " #{valid_protocols.inspect}, not '#{value.upcase}'"
      end
    end

    munge do |value|
      value.upcase
    end
  end

  newproperty(:source_address_translation) do
    desc "The source address translation setting of the virtualserver"

    validate do |value|
      unless ['automap', 'none'].include?(value.downcase) ||
        Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "'source_address_translation' must be 'automap',"\
        " 'none' or a fully qualified path, not '#{value.downcase}'"
      end
    end

    munge do |value|
      value.upcase! if ['automap', 'none'].include?(value.downcase)
      value
    end
  end

  ###########################################################################
  # Profiles
  ###########################################################################
  newproperty(:auth_profiles, :array_matching => :all) do
#    def insync?(is)
#      is == :absent && @should.empty? || is.sort == @should.sort
#    end

    def insync?(is)
      is.sort == @should.sort
    end

    # Actually display an empty list.
    def should_to_s(newvalue)
      newvalue.inspect
    end

    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'auth_profiles' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newproperty(:ftp_profile) do
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'ftp_profile' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newproperty(:http_profile) do
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'http_profile' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newproperty(:oneconnect_profile) do
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'oneconnect_profile' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newproperty(:protocol_profile_client) do
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'protocol_profile_client' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newproperty(:protocol_profile_server) do
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'protocol_profile_server' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newproperty(:responseadapt_profile) do
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'responseadapt_profile' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newproperty(:requestadapt_profile) do
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'requestadapt_profile' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newproperty(:rules, :array_matching => :all) do
    def insync?(is)
      # Don't sort here because the order of rules matters,
      # (we do sort on priority during prefetch)
      is == @should
    end

    # Actually display an empty list.
    def should_to_s(newvalue)
      newvalue.inspect
    end

    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'rules' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newproperty(:sip_profile) do
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'sip_profile' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newproperty(:ssl_profiles_client, :array_matching => :all) do
    # Override insync so it doesn't treat an empty list value 
    # as nil.
    def insync?(is)
      is.sort == @should.sort
    end

    # Actually display an empty list.
    def should_to_s(newvalue)
      newvalue.inspect
    end

    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'ssl_profile_server' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newproperty(:ssl_profiles_server, :array_matching => :all) do
    def insync?(is)
      is.sort == @should.sort
    end

    def should_to_s(newvalue)
      newvalue.inspect
    end

    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'ssl_profile_server' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newproperty(:stream_profile) do
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'stream_profile' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newproperty(:statistics_profile) do
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'atcreate_statistics_profile' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newproperty(:xml_profile) do
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'xml_profile' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newproperty(:type) do
    desc "The virtualserver type"

    def should=(values)
      super(values.upcase)
    end

    validate do |value|
      valid_types =
        ["POOL", "IP_FORWARDING", "L2_FORWARDING", "REJECT", "FAST_L4", "FAST_HTTP", "STATELESS",
         "DHCP_RELAY", "UNKNOWN", "INTERNAL"]

      unless valid_types.include?(value)
        fail Puppet::Error, "Parameter 'type' must be one of:"\
        " #{valid_types.inspect}, not '#{value}'"
      end
    end
  end

  newproperty(:wildmask) do
    desc "The virtualserver wildmask"
  end

  ###########################################################################
  # Parameters used at creation.
  ###########################################################################
  # These attributes are parameters because, often, we want objects to be
  # *created* with property values X, but still let a human make changes
  # to them without puppet getting in the way.
  newparam(:atcreate_description) do
    desc "The virtualserver description at creation."
  end

  newparam(:atcreate_address) do
    desc "The virtualserver address at creation."
  end

  newparam(:atcreate_default_pool) do
    desc "The virtualserver default pool at creation."

    defaultto "" # None
  end

  newparam(:atcreate_port) do
    desc "The virtualserver port at creation."

    munge do |value|
      begin
        Integer(value)
      rescue
        fail Puppet::Error, "Parameter 'atcreate_port' must be a number, not '#{value}'"
      end
    end
  end

  newparam(:atcreate_fallback_persistence_profile) do
    desc "The virtualserver fallback persistence profile at creation."
  end

  newparam(:atcreate_persistence_profile) do
    desc "The virtualserver default persistence profile at creation."
  end

  newparam(:atcreate_protocol) do
    desc "The virtualserver default persistence profile at creation."

    validate do |value|
      valid_protocols =
        ["ANY", "IPV6", "ROUTING", "NONE", "FRAGMENT", "DSTOPTS", "TCP", "UDP", "ICMP", "ICMPV6",
         "OSPF", "SCTP", "UNKNOWN"]

      unless valid_protocols.include?(value)
        fail Puppet::Error, "Parameter '#{self.name}' must be one of:"\
          " #{valid_protocols.inspect}, not '#{value}'"
      end
    end

    munge do |value|
      value.upcase
    end

    defaultto "TCP"
  end

  newparam(:atcreate_auth_profiles) do
    validate do |value|
      value = [value] unless value.is_a?(Array)

      value.each do |item|
        unless Puppet::Util.absolute_path?(item)
          fail Puppet::Error, "Parameter 'atcreate_auth_profiles' must be"\
            " a fully qualified path, not '#{item}'"
        end
      end
    end

    munge do |value|
      value.is_a?(Array) ? value : [value]
    end
  end

  newparam(:atcreate_ftp_profile) do
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'atcreate_ftp_profile' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newparam(:atcreate_http_profile) do
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'atcreate_http_profile' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newparam(:atcreate_oneconnect_profile) do
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'atcreate_oneconnect_profile' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newparam(:atcreate_protocol_profile_client) do
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'atcreate_protocol_profile_client'"\
          " must be a fully qualified path, not '#{value}'"
      end
    end
  end

  newparam(:atcreate_protocol_profile_server) do
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'atcreate_protocol_profile_server'"\
          " must be a fully qualified path, not '#{value}'"
      end
    end
  end

  newparam(:atcreate_requestadapt_profile) do
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'atcreate_requestadapt_profile' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newparam(:atcreate_responseadapt_profile) do
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'atcreate_responseadapt_profile' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newparam(:atcreate_sip_profile) do
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'atcreate_sip_profile' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newparam(:atcreate_ssl_profiles_client) do
    validate do |value|
      value = [value] unless value.is_a?(Array)

      value.each do |item|
        unless Puppet::Util.absolute_path?(item)
          fail Puppet::Error, "Parameter 'atcreate_ssl_profiles_client' must be"\
            " a fully qualified path, not '#{item}'"
        end
      end
    end

    munge do |value|
      value.is_a?(Array) ? value : [value]
    end
  end

  newparam(:atcreate_ssl_profiles_server) do
    validate do |value|
      value = [value] unless value.is_a?(Array)

      value.each do |item|
        unless Puppet::Util.absolute_path?(item)
          fail Puppet::Error, "Parameter 'atcreate_ssl_profiles_server' must be"\
            " a fully qualified path, not '#{item}'"
        end
      end
    end

    munge do |value|
      value.is_a?(Array) ? value : [value]
    end
  end

  newparam(:atcreate_statistics_profile) do
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'atcreate_statistics_profile' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newparam(:atcreate_stream_profile) do
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'atcreate_stream_profile' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newparam(:atcreate_xml_profile) do
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "Parameter 'atcreate_xml_profile' must be"\
          " a fully qualified path, not '#{value}'"
      end
    end
  end

  newparam(:atcreate_rules) do
    validate do |value|
      value = [value] unless value.is_a?(Array)

      value.each do |item|
        unless Puppet::Util.absolute_path?(item)
          fail Puppet::Error, "Parameter 'atcreate_rules' must be"\
            " a fully qualified path, not '#{item}'"
        end
      end

    end

    munge do |value|
      value.is_a?(Array) ? value : [value]
    end
  end

  newparam(:atcreate_source_address_translation) do
    desc "The source address translation setting of the virtualserver"

    validate do |value|
      unless ['AUTOMAP', 'NONE'].include?(value.upcase) ||
        Puppet::Util.absolute_path?(value)
        fail Puppet::Error, "'atcreate_source_address_translation' must be"\
        " 'automap', 'none' or a fully qualified path, not '#{value}'"
      end
    end

    munge do |value|
      value.upcase! if ['automap', 'none'].include?(value.downcase)
      value
    end
  end

  newparam(:atcreate_type) do
    desc "The virtualserver type at creation."

    validate do |value|
      valid_types =
        ["POOL", "IP_FORWARDING", "L2_FORWARDING", "REJECT", "FAST_L4", "FAST_HTTP", "STATELESS",
         "DHCP_RELAY", "UNKNOWN", "INTERNAL"]

      unless valid_types.include?(value.upcase)
        fail Puppet::Error, "Parameter 'type' must be one of:"\
          " #{valid_types.inspect}, not '#{value.upcase}'"
      end
    end

    munge do |value|
      value.upcase
    end

    defaultto "POOL"
  end

  newparam(:atcreate_wildmask) do
    desc "The virtualserver wildmask at creation."

    defaultto "255.255.255.255"
  end

  ###########################################################################
  # Validation
  ###########################################################################
  validate do
    if self[:ensure] == :present
      if self[:address].nil? && self[:atcreate_address].nil?
        fail Puppet::Error, "Parameter 'address' must be defined"
      end

      if self[:port].nil? && self[:atcreate_port].nil?
        fail Puppet::Error, "Parameter 'port' must be defined"
      end
    end
  end

  autorequire(:f5_partition) do
    File.dirname(self[:name]) 
  end

  # TODO: Autorequire all profiles

  autorequire(:f5_pool) do
    if !(self[:default_pool].nil? || self[:default_pool].empty?)
      self[:default_pool]
    elsif !(self[:atcreate_default_pool].nil? || self[:atcreate_default_pool].empty?)
      self[:atcreate_default_pool]
    end
  end

end
