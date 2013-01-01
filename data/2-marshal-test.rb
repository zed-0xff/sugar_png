#!/usr/bin/env ruby
require 'hexdump'
require 'awesome_print'

def dump x
  data = Marshal.dump(x)
  printf "[.] %4d: %-10s (%d): %s\n".green, data.size, x.class.to_s, x.size, x.inspect[0,30].gray
  Hexdump.dump data
  puts
end

dump 0
dump 0xff
dump [0] * 10
dump [0xff] * 10
dump 'x'
dump 'x'*100
dump ['x']*100

a = [1,2,3,4,5]
dump a
dump [a]*10
