module Prism
  require 'rubygems' if RUBY_VERSION < "1.9"
  %w(net/http ipaddr rexml/document).each{|lib| require lib}


  def self.get_header(uri,header='x-amz-meta-sha256-hash', port=80)
    uri = URI(uri)
    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Head.new uri.request_uri
      response = http.request request
      result =  response[header]
      Chef::Log.info("[CHEF] #{header} -> (#{result})")
      return result
    end

  rescue Timeout::Error, Errno::EHOSTDOWN, Errno::ECONNREFUSED => e
    Chef::Log.warn("[CHEF] get_header  #{e}")
    Chef::Log.warn("[CHEF] #{header} -> (0)")
    return 0
  end

  #http://evolution.voxeo.com/ticket/1673456
  def self.requires_glibc_patch(arch)
    glibc = `rpm -qa | grep "glibc-2.1" | grep #{arch}`.split("-")[1]
    if glibc
      # We are doing tbhis because Ruby doesnt really have a clean way of doing natual order
      return (glibc.split('.').map{|s|s.to_i} <=> "2.5".split('.').map{|s|s.to_i}) > 0
    else
      false
    end
  end

  def self.mrcp_sessions(ip_address,port=10099)
    http = Net::HTTP.new("#{ip_address}",port)
    http.read_timeout = 2
    http.open_timeout = 2
    r = REXML::Document.new(http.get("/stats_10?type=cooked").body).elements.each("//counters/item[@name='MRCP/Sessions']"){|ele| ele}.first.text.to_i
    #http.get("/stats_10?type=cooked").body.elements.each("//counters/item[@name='MRCP/Sessions']"){|ele| p ele.text.to_i}
    #r = Nokogiri::XML(http.get("/stats_10?type=cooked").body).xpath("//counters/item[@name='MRCP/Sessions']").text.to_i
    Chef::Log.info("[PRISM] MRCP Sessions (#{ip_address}) ====> #{r}")
    return r
  rescue Timeout::Error, Errno::EHOSTDOWN, Errno::ECONNREFUSED => e
    Chef::Log.info("[PRISM] MRCP Sessions #{e}")
    Chef::Log.info("[PRISM] MRCP Sessions (#{ip_address}) ====> 0")
    return 0
  end


  def self.media_server_running?(ip_address="127.0.0.1",port=10086)
    http = Net::HTTP.new("#{ip_address}",port)
    http.read_timeout = 2
    http.open_timeout = 2
    r = REXML::Document.new(http.get("/scm_10?action=status").body).elements.each("//config/category/category[@name='ms']/item[@name='Status']"){|ele| ele}.first.text.strip.eql?("Running")
    #r = Nokogiri::XML(http.get("/scm_10?action=status").body).xpath("//config/category/category[@name='ms']/item[@name='Status']").text.strip.eql?("Running")
    Chef::Log.info("[PRISM] media_server_running? (#{ip_address}) ====> #{r}")
    return r
  rescue Timeout::Error, Errno::EHOSTDOWN, Errno::ECONNREFUSED => e
    Chef::Log.info("[PRISM] media_server_running? #{e}")
    Chef::Log.info("[PRISM] media_server_running? (#{ip_address}) ====> 0")
    return false
  end


  def self.app_server_running?(ip_address="127.0.0.1",port=10086)
    http = Net::HTTP.new("#{ip_address}",port)
    http.read_timeout = 2
    http.open_timeout = 2
    r = REXML::Document.new(http.get("/scm_10?action=status").body).elements.each("//config/category/category[@name='as']/item[@name='Status']"){|ele| ele}.first.text.strip.eql?("Running")
    #r = Nokogiri::XML(http.get("/scm_10?action=status").body).xpath("//config/category/category[@name='as']/item[@name='Status']").text.strip.eql?("Running")
    Chef::Log.info("[PRISM] app_server_running? (#{ip_address}) ====> #{r}")
    return r
  rescue Timeout::Error, Errno::EHOSTDOWN, Errno::ECONNREFUSED => e
    Chef::Log.info("[PRISM] app_server_running? #{e}")
    Chef::Log.info("[PRISM] app_server_running? (#{ip_address}) ====> 0")
    return false
  end
  # require 'ipaddr'
  # class IPAddr
  #   PrivateRanges = [
  #     IPAddr.new("10.0.0.0/8"),
  #     IPAddr.new("172.16.0.0/12"),
  #     IPAddr.new("192.168.0.0/16")
  #   ]

  #   def private?
  #     return false unless self.ipv4?
  #     PrivateRanges.each do |ipr|
  #       return true if ipr.include?(self)
  #     end
  #     return false
  #   end

  #   def public?
  #     !private?
  #   end
  # end

  # If a user provides an relay_address in sipmethod.xml we know they are going to provide a relay_port, the question
  # is wheather or not that is going to be a different port.  If they dont provide a port we just reuse the internal one.
  # We also use the internal ip for 'address' as well.

  def self.nat_mapping(opts={})
    if opts[:relay_address]
      if opts[:relay_port]
        raise "Invalid Port" unless (1..65335).include? opts[:relay_port].to_i
        # Send port should only be there for a SMS Gateway deployment, not the prettiest way to do this, I know /sigh
        "address='#{opts[:address]}' relayAddress='#{opts[:relay_address]}' relayPort='#{opts[:relay_port]}' #{"sendPort='" + opts[:send_port] + "'" if opts[:send_port]}"
      else
        "address='#{opts[:address]}' relayAddress='#{opts[:relay_address]}' relayPort='#{opts[:port]}'"
      end
    end
  end

  def self.jmx(opts={})
    opts={
      :port => 47520,
      :ip   => 'localhost',
      :bean => 'com.micromethod.sipmethod:name=sip,type=server.service',
      :item => 'ActiveSession'
    }.merge!(opts)

    jmx = system("java -jar /usr/bin/jmxsh.jar /usr/bin/active_sessions.tcl #{opts[:ip]} #{opts[:port]} #{opts[:bean]} #{opts[:item]} 2>&1")
    if jmx.start_with?('Error')
      Chef::Log.info("[PRISM]===> JMX Request failed [#{jmx}]")
      1
    else
      Chef::Log.info("[PRISM]===> JMX response [#{jmx.chomp}]")
      jmx.to_i
    end
  end

  def self.get_public_ipv4
    Net::HTTP.get('ip.voxeolabs.net', '/').split(":")[1][/\b(?:\d{1,3}\.){3}\d{1,3}\b/]
  end

  def self.installer_options(node)
    if node[:prism][:install_sip_point] && node[:prism][:install_tropo]
      '-DCONSOLE_PRISM_MODULES=\"SIPoint\",\"Tropo\"' # ==> deploy SIPoint & Tropo
    else
      if node[:prism][:install_sip_point]
        '-DCONSOLE_PRISM_MODULES=\"SIPoint\"' # ==> deploy SIPoint
      elsif node[:prism][:install_tropo]
        '-DCONSOLE_PRISM_MODULES=\"Tropo\"' # ==> deploy Tropo
      else
        #'-DCONSOLE_PRISM_MODULES=\"\",\"\"' Should work but doesnt, FML InstallAnywhere
        '-DCONSOLE_PRISM_MODULES_BOOLEAN_1=0 -DCONSOLE_PRISM_MODULES_BOOLEAN_2=0'  # ==> deploy nothing
      end
    end
  end


  class << self
    alias active_sessions jmx
    alias get_checksum get_header
  end
end
