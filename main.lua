require("lib.ammo")
require("lib.physics")
require("lib.assets")
require("lib.input")
require("lib.tweens")
require("lib.postfx")
require("graphics")
slaxml = require("slaxdom")

require("misc.utils")
require("misc.xmlFuncs")

require("entities.Floor")
require("entities.Walls")
require("entities.Player")
require("entities.Turret")
require("entities.Rocket")
require("entities.Bullet")
require("entities.Pellet")

require("worlds.Level")

function love.load()
  assets.loadImage("tiles.png")
  assets.loadImage("player.png")
  assets.loadImage("turret-base.png", "turretBase")
  assets.loadImage("turret-gun.png", "turretGun")
  assets.loadImage("rocket.png")
  for _, v in pairs(assets.images) do v:setFilter("nearest", "nearest") end
  
  postfx.init()
  postfx.scale = 2
  
  input.define("left", "a", "left")
  input.define("right", "d", "right")
  input.define("up", "w", "up")
  input.define("down", "s", "down")
  input.define{"fire", mouse = "l" }
  input.define{"ability", mouse = "r" }
  
  ammo.world = Level:new("1")
end

function love.update(dt)
  ammo.update(dt)
  input.update()
end

function love.draw()
  postfx.start()
  ammo.draw()
  postfx.stop()
end
