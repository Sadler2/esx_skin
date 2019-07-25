resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Skin'

version '1.1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'locales/ru.lua',
	'locales/description/ru.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'locales/ru.lua',
	'config.lua',
	'client/util.lua',
	'locales/description/ru.lua',
	'locales/description/en.lua',
	'client/description.lua',
	'client/main.lua'
}

dependencies {
	'es_extended',
	'skinchanger'
}

exports {
	'getSkinDescription',
	'skinDescriptionToText',
}
