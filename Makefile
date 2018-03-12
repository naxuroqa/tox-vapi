CFLAGS=-g -ftest-coverage -fprofile-arcs $(shell pkg-config --cflags gio-2.0 toxcore)
LDFLAGS=$(shell pkg-config --libs gio-2.0 toxcore)

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
		--debug \
		examples/Bot.vala

echobot:
	valac \
		--vapidir=vapi \
		--pkg=gio-2.0 \
		--pkg=toxcore \
		--pkg=toxav \
		--pkg=toxencryptsave \
		--pkg=posix \
		--debug \
		examples/echobot/Echobot.vala

examples: bot echobot

test-options-bin:
	valac \
		--vapidir=vapi \
		--pkg=gio-2.0 \
		--pkg=toxcore \
		--pkg=toxav \
		--pkg=toxencryptsave \
		--ccode \
		--debug \
		tests/ToxOptionsTest.vala
	gcc \
		$(CFLAGS) \
		-o ToxOptionsTest \
		tests/ToxOptionsTest.c \
		$(LDFLAGS)

test-core-bin:
	valac \
		--vapidir=vapi \
		--pkg=gio-2.0 \
		--pkg=toxcore \
		--pkg=toxav \
		--pkg=toxencryptsave \
		--ccode \
		--debug \
		tests/ToxCoreTest.vala
	gcc \
		$(CFLAGS) \
		-o ToxCoreTest \
		tests/ToxCoreTest.c \
		$(LDFLAGS)

test-av-bin:
	valac \
		--vapidir=vapi \
		--pkg=gio-2.0 \
		--pkg=toxcore \
		--pkg=toxav \
		--pkg=toxencryptsave \
		--ccode \
		--debug \
		tests/ToxAVTest.vala
	gcc \
		$(CFLAGS) \
		-o ToxAVTest \
		tests/ToxAVTest.c \
		$(LDFLAGS)

test-encrypt-bin:
	valac \
		--vapidir=vapi \
		--pkg=gio-2.0 \
		--pkg=toxcore \
		--pkg=toxav \
		--pkg=toxencryptsave \
		--ccode \
		--debug \
		tests/ToxEncryptSaveTest.vala
	gcc \
		$(CFLAGS) \
		-o ToxEncryptSaveTest \
		tests/ToxEncryptSaveTest.c \
		$(LDFLAGS)

test: test-options-bin test-core-bin test-av-bin test-encrypt-bin
	gtester --verbose ToxOptionsTest ToxCoreTest ToxAVTest ToxEncryptSaveTest

debug: bot
	gdb -ex run ./Bot

clean:
	rm -f Bot Echobot ToxOptionsTest ToxCoreTest ToxAVTest ToxEncryptSaveTest tests/*.c *.gcda *.gcno
	rm -rf ./docs ./build

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
