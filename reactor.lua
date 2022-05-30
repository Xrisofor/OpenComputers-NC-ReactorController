local component = require("component")
local event = require("event")
local io = require("io")
local gpu = component.gpu
local shell = require("shell")
local term = require("term")

local version = "0.1.0"

gpu.setResolution(50, 25)
gpu.setBackground(0xFFFFFF)
gpu.setForeground(0x000000)

local function error_(message)
  term.clear()  
  gpu.setForeground(0xFF0000)
  print("Error: "..message)
  gpu.setForeground(0x000000)
  print("")
  print("Press any key to exit")
  io.read()
  os.exit()
  return
end

if not component.isAvailable("nc_fission_reactor") then
  error_("The reactor is not connected to the computer! Please connect the reactor.")
end

local reactor = component.nc_fission_reactor

local function start_screen()
  term.clear()
  print("Welcome to Reactor Controller!")
  print("Tap on the screen to select actions!")
end

local function choose_screen()
  term.clear()
  print("Welcome to Reactor Controller!")
  print("Reactor Problem: "..reactor.getProblem())
  print("")
  print("Choose:")
  print("1 - Activate")
  print("2 - Deactivate")
  print("3 - Info")
  print("")
  print("Version: "..version)
  print("CTRL + ALT + C to exit")
end

local function activate_screen()
  term.clear()
  print("Welcome to Reactor Controller!")
  print("Reactor Problem: "..reactor.getProblem())
  print("")
  print("Reactor activated!")
  reactor.activate()
  os.sleep(3)
end

local function deactivate_screen()
  term.clear()
  print("Welcome to Reactor Controller")
  print("Reactor Problem: "..reactor.getProblem())
  print("")
  print("Reactor deactivated!")
  reactor.deactivate()
  os.sleep(3)
end

local function info_screen()
  term.clear()
  print("Welcome to Reactor Controller")
  print("Reactor Problem: "..reactor.getProblem())
  print("")
  print("Reactor Heat Multiplier: "..math.floor(reactor.getHeatMultiplier()/10)*10 .. "%")
  print("Reactor Cells: "..reactor.getNumberOfCells())
  print("")  
  print("Reactor Fuel: "..reactor.getFissionFuelName())
  print("Reactor Fuel Energy: "..reactor.getFissionFuelPower())
  print("Reactor Base Fuel Depletion Time: "..math.floor((reactor.getFissionFuelTime() / 1200)*100)/100 .. " min")
  print("Reactor Actual Depletion Time: "..math.floor((reactor.getReactorProcessTime() / 1200)*100)/100 .. " min")
  print("Reactor Efficiency: "..math.floor(reactor.getEfficiency()*10)/10 .. "%")  
  print("")
  print("Press any key to go back")
  io.read()
end

start_screen()

while true do
  local event = event.pull()
  if event == "touch" then
    while true do
      choose_screen()
      local selection = io.read()
      if selection == "1" then
        activate_screen()
      elseif selection == "2" then
        deactivate_screen()
      elseif selection == "3" then
        info_screen()
      end
    end
  end
end