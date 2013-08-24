local path = ({...})[1]:gsub("%.init", "") 
require(path .. ".Spritemap")
require(path .. ".Tilemap")
if ammo then require(path .. ".ammo") end
