resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ARF by Lance Good'

client_scripts {
  'client/client.lua'
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'config/config.lua',
  'server/server.lua',
  'server/functions.lua'
}