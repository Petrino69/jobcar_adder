fx_version 'cerulean'
game 'gta5'

author 'Petrino'
description 'add job car to owned_vehicles'
version '1.0.1'

shared_script '@es_extended/imports.lua'
client_script 'client.lua'
server_script {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}
