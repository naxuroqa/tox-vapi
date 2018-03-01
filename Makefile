bot:
	valac \
		--vapidir=vapi \
		--pkg=gio-2.0 \
		--pkg=libsoup-2.4 \
		--pkg=json-glib-1.0 \
		--pkg=libtoxcore \
		--pkg=libtoxav \
		--target-glib=2.32 \
		-g \
		Bot.vala

debug: bot
	gdb -ex run ./Bot

clean:
	rm -f ./Bot
	rm -rf ./docs

style:
	uncrustify \
		-c uncrustify.cfg \
		-l VALA \
		--replace \
		--no-backup \
		vapi/libtoxcore.vapi \
		vapi/libtoxav.vapi \
		Bot.vala

docs:
	valadoc \
		--directory docs \
		--package-name libtoxcore \
		vapi/libtoxcore.vapi \
		vapi/libtoxav.vapi \
		vapi/toxencryptsave.vapi
