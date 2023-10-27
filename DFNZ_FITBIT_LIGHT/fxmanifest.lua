fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'DFNZ'
description 'Fitbit for tracking your health, hunger and thirst'
version 'LIGHT.1.0'

shared_script {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua'
}

files {
    "locales/*.json"
}

client_scripts {
    "shared/config.lua",
    "client/main.lua"
}

server_scripts {
    "shared/config.lua",
    "server/main.lua"
}