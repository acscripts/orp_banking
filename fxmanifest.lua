fx_version 'cerulean'
game 'gta5'

author 'HiHowdy & ANTOND.#8507'
description 'Banking script with qtarget support.'
version '2.0.0'


shared_script '@es_extended/imports.lua'
server_script 'server.lua'

client_scripts {
	'config.lua',
	'client.lua'
}


ui_page 'html/index.html'

files {
	'html/index.html',
	'html/script.js',
	'html/style.css',
	'html/logo.png'
}
