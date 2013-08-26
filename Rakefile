task :default do
  puts `/Applications/love.app/Contents/MacOS/love .`
end

task :lines do
  puts `wc -l *.lua modules/*.lua misc/*.lua entities/*.lua entities/*/*.lua worlds/*.lua`
end

task :package do
  puts `zip -r --exclude=*.git* --exclude=*.bfxrlibrary --exclude=*.DS_Store* _bin/triad.love assets entities misc graphics lib worlds *.lua`
end
