#!/usr/bin/env ruby
%w[monday tuesday wednesday thursday friday].map do |d|
  r="#{d.upcase} FUNDAY"
  puts r
  1.upto(r.length) { print '=' }
  print "\n\n\n"
end
