bot:
	valac \
		--vapidir=vapi \
		--pkg=gio-2.0 \
		--pkg=libsoup-2.4 \
		--pkg=json-glib-1.0 \
		--pkg=toxcore \
		--pkg=toxav \
		--pkg=toxencryptsave \
		--target-glib=2.32 \
		-g \
		examples/Bot.vala

echobot:
	valac \
		--vapidir=vapi \
		--pkg=gio-2.0 \
		--pkg=toxcore \
		--pkg=toxav \
		--pkg=toxencryptsave \
		--pkg=posix \
		-g \
		examples/echobot/Echobot.vala

examples: bot echobot

test-options-bin:
	valac \
		--vapidir=vapi \
		--pkg=gio-2.0 \
		--pkg=toxcore \
		--pkg=toxav \
		--pkg=toxencryptsave \
		-g \
		tests/ToxOptionsTest.vala

test-core-bin:
	valac \
		--vapidir=vapi \
		--pkg=gio-2.0 \
		--pkg=toxcore \
		--pkg=toxav \
		--pkg=toxencryptsave \
		-g \
		tests/ToxCoreTest.vala

test-av-bin:
	valac \
		--vapidir=vapi \
		--pkg=gio-2.0 \
		--pkg=toxcore \
		--pkg=toxav \
		--pkg=toxencryptsave \
		-g \
		tests/ToxAVTest.vala

test-encrypt-bin:
	valac \
		--vapidir=vapi \
		--pkg=gio-2.0 \
		--pkg=toxcore \
		--pkg=toxav \
		--pkg=toxencryptsave \
		-g \
		tests/ToxEncryptSaveTest.vala

test: test-options-bin test-core-bin test-av-bin test-encrypt-bin
	gtester --verbose ToxOptionsTest ToxCoreTest ToxAVTest ToxEncryptSaveTest

debug: bot
	gdb -ex run ./Bot

clean:
	rm -f Bot Echobot ToxOptionsTest ToxCoreTest ToxAVTest ToxEncryptSaveTest
	rm -rf ./docs

style:
	uncrustify \
		-c uncrustify.cfg \
		-l VALA \
		--replace \
		--no-backup \
		vapi/toxcore.vapi \
		vapi/toxav.vapi \
		vapi/toxencryptsave.vapi \
		tests/ToxCoreTest.vala \
		tests/ToxOptionsTest.vala \
		tests/ToxAVTest.vala \
		tests/ToxEncryptSaveTest.vala \
		examples/Bot.vala \
		examples/echobot/Echobot.vala

docs:
	valadoc \
		--directory docs \
		--package-name toxcore \
		vapi/toxcore.vapi \
		vapi/toxav.vapi \
		vapi/toxencryptsave.vapi
