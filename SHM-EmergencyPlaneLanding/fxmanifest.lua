--[[
   _____ __         __  ___       __       __  ___          ___ _____            __  _                 
  / ___// /____  __/ / / (_)___ _/ /_     /  |/  /___  ____/ (_) __(_)________ _/ /_(_)___  ____  _____
  \__ \/ //_/ / / / /_/ / / __ `/ __ \   / /|_/ / __ \/ __  / / /_/ / ___/ __ `/ __/ / __ \/ __ \/ ___/
 ___/ / ,< / /_/ / __  / / /_/ / / / /  / /  / / /_/ / /_/ / / __/ / /__/ /_/ / /_/ / /_/ / / / (__  ) 
/____/_/|_|\__, /_/ /_/_/\__, /_/ /_/  /_/  /_/\____/\__,_/_/_/ /_/\___/\__,_/\__/_/\____/_/ /_/____/  
          /____/        /____/                                                                         
--]] 

fx_version "cerulean"
game "gta5"
description "EmergencyAircraftLanding"
version "1.0.0"
beta_version "1.0.0"
author "SkyHigh Modifications / @Papa Smurf / "
lua54 "yes"

server_script 'server.lua'

client_scripts {
    'client.lua',
    'config.lua'
}
