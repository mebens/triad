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
require("misc.noise")

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
require("entities.Chunk")
require("entities.Smoke")

require("worlds.LevelBase")
require("worlds.LevelPlanning")
require("worlds.LevelWave")
require("worlds.Tutorial")

TILE_SIZE = 9

function love.load()
  assets.loadFont("uni05.ttf", { 16, 8 }, "main")
  assets.loadMusic("music.mp3")
  assets.loadEffect("noise.frag")
  
  assets.loadImage("tiles.png")
  assets.loadImage("crosshair.png")
  assets.loadImage("player-mg.png", "playerMg")
  assets.loadImage("player-ps.png", "playerPs")
  assets.loadImage("player-sg.png", "playerSg")
  assets.loadImage("player-shield.png", "playerShield")
  assets.loadImage("player-legs.png", "playerLegs")
  assets.loadImage("turret-base.png", "turretBase")
  assets.loadImage("turret-gun.png", "turretGun")
  assets.loadImage("weak-wall.png", "weakWall")
  assets.loadImage("smoke.png")
  assets.loadImage("rocket.png")
  assets.loadImage("tutorial-mg.png", "tutorialMg")
  assets.loadImage("tutorial-ps.png", "tutorialPs")
  assets.loadImage("tutorial-sg.png", "tutorialSg")
  assets.loadImage("tutorial-walls.png", "tutorialWalls")
  for _, v in pairs(assets.images) do v:setFilter("nearest", "nearest") end
  
  assets.loadSfx("death1.mp3")
  assets.loadSfx("death2.mp3")
  assets.loadSfx("explosion1.mp3", 0.8)
  assets.loadSfx("explosion2.mp3")
  assets.loadSfx("explosion3.mp3", 0.8)
  assets.loadSfx("explosion4.mp3")
  assets.loadSfx("shoot1.mp3", 0.65)
  assets.loadSfx("shoot2.mp3", 0.65)
  assets.loadSfx("shoot3.mp3", 0.65)
  assets.loadSfx("shotgun1.mp3", 0.8)
  assets.loadSfx("shotgun2.mp3", 0.8)
  assets.loadSfx("shield1.mp3", 0.5)
  assets.loadSfx("shield2.mp3", 0.5)
  assets.loadSfx("shield3.mp3", 0.5)
  assets.loadSfx("hit1.mp3")
  assets.loadSfx("hit2.mp3")
  assets.loadSfx("rocket1.mp3", 0.7)
  assets.loadSfx("rocket2.mp3", 0.7)  
  assets.loadSfx("smoke1.mp3", 0.3)
  assets.loadSfx("smoke2.mp3", 0.3)
  assets.loadSfx("step1.mp3", 0.3)
  assets.loadSfx("step2.mp3", 0.3)
  assets.loadSfx("step3.mp3", 0.3)
  assets.loadSfx("step4.mp3", 0.3)
  
  noise:init()
  postfx.init()
  postfx.scale = 2
  postfx.add(noise)
  love.graphics.width = love.graphics.width / postfx.scale
  love.graphics.height = love.graphics.height / postfx.scale
  love.mouse.setVisible(false)
  
  input.define("left", "a", "left")
  input.define("right", "d", "right")
  input.define("up", "w", "up")
  input.define("down", "s", "down")
  input.define{"fire", mouse = "l" }
  input.define{"ability", mouse = "r" }
  input.define("progress", " ")
  input.define("restart", "r")
  input.define("muteMusic", "m")
  input.define("quit", "escape")
  
  music = assets.music.music:loop()
  musicMuted = false
  ammo.world = Tutorial:new()
end

function love.update(dt)
  fade.update(dt)
  postfx.update(dt)
  ammo.update(dt)
  if input.pressed("quit") then love.event.quit() end
  
  if input.pressed("muteMusic") then
    musicMuted = not musicMuted
    music:setVolume(musicMuted and 0 or 1)
  end
  
  input.update()
end

function love.draw()
  postfx.start()
  ammo.draw()
  postfx.stop()
  fade.draw()
end
