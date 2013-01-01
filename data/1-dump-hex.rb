#!/usr/bin/env ruby

fname = ARGV.first || "unifont-5.1.20080820.hex"

want = ARGV[1] && ARGV[1].to_i(16)

File.read(fname).each_line do |line|
  idx, data = line.strip.split(':',2)
  idx = idx.to_i(16)
  next if want && want != idx
  case data.size
  when 32
    data.scan(/../).each do |x|
      puts(("%08b" % x.to_i(16)).tr('01',' #'))
    end
  when 64
    data.scan(/..../).each do |x|
      puts(("%016b" % x.to_i(16)).tr('01',' #'))
    end
  else raise data.size.to_s
  end
end
