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
		groupbot/Bot.vala

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

test: test-options test-core

debug: bot
	gdb -ex run ./Bot

clean:
	rm -f ./Bot
	rm -f ./ToxOptionsTest
	rm -f ./ToxCoreTest
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
		groupbot/Bot.vala

docs:
	valadoc \
		--directory docs \
		--package-name toxcore \
		vapi/toxcore.vapi \
		vapi/toxav.vapi \
		vapi/toxencryptsave.vapi
