local component = require("component")
local computer = require("computer")
local fs = require("filesystem")
local event = require("event")
local term = require("term")
local shell = require("shell")
local gpu = component.gpu

local repositoryURL = "https://raw.githubusercontent.com/Xrisofor/OpenComputers-NC-ReactorController/master/"
local args, options = shell.parse(...)

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
end

if not component.isAvailable("internet") then
  error_("The internet card is not connected! Please connect the internet card.")
end

local internet = component.internet

local function start_screen()
  term.clear()
  print("Welcome to Reactor Controller Installer!")
  print("Tap the screen to start!")
end

local result, reason = ""

local function reboot_screen()
  term.clear()
  print("Welcome to Reactor Controller Installer!")
  print("")
  print("Installation in complete!")
  print("Restart the computer? [y/n]")
  local selection = io.read()
  if selection == "y" then
    computer.shutdown(true)
  elseif selection == "Y" then
    computer.shutdown(true)
  else
    os.exit()
  end
end

local function download(url, filename)
  fs.makeDirectory("/ReactorController")
  local f, reason = io.open(filename, "w")
  if not f then
    error_("Failed opening file for  writing: "..reason)
  end

  term.clear()
  print("Welcome to Reactor Controller Installer!")
  print("")
  print("Downloading file from github.com...")
  local url = repositoryURL..url
  local handle, chunk = internet.request(url)
  while true do
    chunk = handle.read(math.huge)
    
    if chunk then
      result = result..chunk
    else
      break
    end
  end
  handle.close()
  f:write(result)
  f:close()
  print("Success Download!")
end

local function install_screen()
  term.clear()
  print("Welcome to Reactor Controller Installer!")
  print("")
  donwload("autorun.lua", "/ReactorController/autorun.lua")
  download("reactor.lua", "/ReactorController/reactor.lua")
  os.sleep(1.5)
  reboot_screen()
end

start_screen()

while true do
  local event = event.pull()
  if event == "touch" then
    install_screen()
  end
end