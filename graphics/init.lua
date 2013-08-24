local path = ({...})[1]:gsub("%.init", "") 
require(path .. ".Spritemap")
require(path .. ".Tilemap")
require(path .. ".Text")
if ammo then require(path .. ".ammo") end
