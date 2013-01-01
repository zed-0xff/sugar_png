#!/usr/bin/env ruby

fname = ARGV.first || "unifont-5.1.20080820.hex"

want = ARGV[1] && ARGV[1].to_i(16)

h = {}
a = []
dedup = {}
aa = []

File.read(fname).each_line do |line|
  idx, data = line.strip.split(':',2)
  idx = idx.to_i(16)
  s = data.scan(/../).map{ |x| x.to_i(16).chr }.join
  s = (dedup[s] ||= s)
#  unless s.split('').uniq == ["\x00"]
    h[idx] = s
    a[idx] = s
    aa[idx >> 8] ||= []
    aa[idx >> 8][idx & 0xff] = s
#  end
end

puts "[=] #{aa.size} pages"
puts "[=] #{aa.uniq.size} unique pages"

# dedup pages
aa.each_with_index do |page,idx|
  (idx+1).upto(aa.size-1) do |idx2|
    aa[idx2] = page if aa[idx2] == page
  end
end

puts "[=] #{h.size} non-empty chars"
puts "[=] #{h.values.uniq.size} unique chars"

puts "[=] #{h.values.join.size} bytes raw data size"

data = Marshal.dump(h)
puts "[=] #{data.size} bytes marshaled hash"

data = Marshal.dump(a)
puts "[=] #{data.size} bytes marshaled array"

data = Marshal.dump(aa)
puts "[=] #{data.size} bytes marshaled array2"

# .index header     =  512 bytes
# .index data       = 1024 bytes (256 pages of 4 bytes each)
# first file header =  512 bytes
#index = ''
#offset = 512 + 1024 + 512
aa.each_with_index do |a,pageno|
  # skip empty pages and pages entirely of one glyph (most likely Unassigned ones)
  next if a.nil? || a.empty? || a.uniq.size == 1
  fname = "font/%02x" % pageno
  data = Marshal.dump(a)
  puts "[.] #{fname}: #{data.size}"
  File.open(fname, "wb"){ |f| f << data }

#  index << [offset].pack('V')
#
#  size = data.size
#  if size & 0x1ff != 0
#    size = (size|0x1ff) + 1
#  end
#  offset += size+512 # add TAR header size
end

#File.open('data/.index','wb'){ |f| f<<index }
