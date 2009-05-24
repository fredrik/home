#!/usr/bin/env ruby
out=""
%w[MONDAY TUESDAY WEDNESDAY THURSDAY FRIDAY].each do |someday|
  caption = "#{someday} FUNDAY"
  out << caption + "\n"
  caption.length.times { out << '=' }
  out << "\n\n\n"
end
print out
