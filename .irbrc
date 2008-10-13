IRB.conf[:AUTO_INDENT] = true
IRB.conf[:USE_READLINE] = true

IRB.conf[:LOAD_MODULES] = []  unless IRB.conf.key?(:LOAD_MODULES)
unless IRB.conf[:LOAD_MODULES].include?('irb/completion')
  IRB.conf[:LOAD_MODULES] << 'irb/completion'
end      

require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 1024
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"
