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

test-options-bin:
	valac \
		--vapidir=vapi \
		--pkg=gio-2.0 \
		--pkg=toxcore \
		--pkg=toxav \
		--pkg=toxencryptsave \
		-g \
		tests/ToxOptionsTest.vala

test-options: test-options-bin
	./ToxOptionsTest

test-core-bin:
	valac \
		--vapidir=vapi \
		--pkg=gio-2.0 \
		--pkg=toxcore \
		--pkg=toxav \
		--pkg=toxencryptsave \
		-g \
		tests/ToxCoreTest.vala

test-core: test-core-bin
	./ToxCoreTest

test-av-bin:
	valac \
		--vapidir=vapi \
		--pkg=gio-2.0 \
		--pkg=toxcore \
		--pkg=toxav \
		--pkg=toxencryptsave \
		-g \
		tests/ToxAVTest.vala

test-av: test-av-bin
	./ToxAVTest

test-encrypt-bin:
	valac \
		--vapidir=vapi \
		--pkg=gio-2.0 \
		--pkg=toxcore \
		--pkg=toxav \
		--pkg=toxencryptsave \
		-g \
		tests/ToxEncryptSaveTest.vala

test-encrypt: test-encrypt-bin
	./ToxEncryptSaveTest

test: test-options test-core test-av test-encrypt

debug: bot
	gdb -ex run ./Bot

clean:
	rm -f ./Bot
	rm -f ./ToxOptionsTest
	rm -f ./ToxCoreTest
	rm -f ./ToxAVTest
	rm -f ./ToxEncryptSaveTest
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
		examples/Bot.vala

docs:
	valadoc \
		--directory docs \
		--package-name toxcore \
		vapi/toxcore.vapi \
		vapi/toxav.vapi \
		vapi/toxencryptsave.vapi
