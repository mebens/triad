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
require("misc.fade")

require("entities.HUD")
require("entities.Floor")
require("entities.Walls")
require("entities.Player")
require("entities.Replayer")
require("entities.PlayerSelection")
require("entities.Turret")
require("entities.Rocket")
require("entities.Bullet")
require("entities.Pellet")
require("entities.WeakWall")
require("entities.WallChunk")
require("entities.Smoke")

require("worlds.LevelBase")
require("worlds.LevelPlanning")
require("worlds.LevelWave")

TILE_SIZE = 9

function love.load()
  assets.loadFont("uni05.ttf", { 16, 8 }, "main")
  assets.loadImage("tiles.png")
  assets.loadImage("player-mg.png", "playerMg")
  assets.loadImage("player-Ps.png", "playerPs")
  assets.loadImage("player-sg.png", "playerSg")
  assets.loadImage("player-shield.png", "playerShield")
  assets.loadImage("player-legs.png", "playerLegs")
  assets.loadImage("turret-base.png", "turretBase")
  assets.loadImage("turret-gun.png", "turretGun")
  assets.loadImage("weak-wall.png", "weakWall")
  assets.loadImage("smoke.png")
  assets.loadImage("rocket.png")
  for _, v in pairs(assets.images) do v:setFilter("nearest", "nearest") end
  
  postfx.init()
  postfx.scale = 2
  love.graphics.width = love.graphics.width / postfx.scale
  love.graphics.height = love.graphics.height / postfx.scale
  
  input.define("left", "a", "left")
  input.define("right", "d", "right")
  input.define("up", "w", "up")
  input.define("down", "s", "down")
  input.define{"fire", mouse = "l" }
  input.define{"ability", mouse = "r" }
  input.define("progress", " ")
  input.define("restart", "r")
  
  paused = false
  ammo.world = LevelPlanning:new(1)
end

function love.update(dt)
  fade.update(dt)
  ammo.update(dt)
  input.update()
end

function love.draw()
  postfx.start()
  ammo.draw()
  postfx.stop()
  fade.draw()
end
