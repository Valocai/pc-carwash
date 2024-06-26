fx_version 'cerulean'
game {'gta5'}

Author 'PickleCord'
description 'Fully Fledged ingame application system with discord integration.'
version '1.0.0'
lua54 'yes'

client_scripts {
    'client.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config/config.lua',
}

ox_libs {
    'interface',
    'zones',
    'menu',
    'progress',
    'notifications',
}