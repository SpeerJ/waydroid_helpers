require 'optparse'

##### Set Resolution on Waydroid Android virt for linux + wayland
dimensions = [:height, :width]
orientations = [:landscape, :portrait]
Options = Struct.new(:height, :width, :preset, :orientation)
options = Options.new()
OptionParser.new do |parser|
  options.to_h.keys.each do |member|
    parser.on("-#{member.to_s[0]}#{member.to_s.upcase}", "--#{member.to_s}#{member.to_s.upcase}",) do |h|
      next options[member] = Integer(h) if dimensions.include?(member)
      options[member] = h
    end
  end
end.parse!

presets = {
  monitor: {width: 1920, height: 1080} # Fill with your preset resolutions
}

dimensions.each do |param|
  original_param = param
  param = dimensions.find {|x| x != param} if(options.orientation == 'portrait')
  val = presets[options.preset&.to_sym]&.dig(original_param) || options[original_param]
  next if val == nil
  puts "Setting #{param} to #{val}"
  puts `waydroid prop set persist.waydroid.#{param} "#{val}"`
end

`waydroid session stop`
fork do
  system("waydroid session start")
end

fork do
  system("waydroid show-full-ui")
end

puts 'started'
