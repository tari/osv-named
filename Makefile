
.PHONY: module clean
module: named.so usr.manifest

named.so:
	make -C bind-9.10.1
	cp bind-9.10.1/bin/named/named named.so

usr.manifest: named.so
	echo '[manifest]' > usr.manifest
	echo '/named/named.so: $${MODULE_DIR}/named.so' >> usr.manifest
	echo '/named/named.conf: $${MODULE_DIR}/named.conf' >> usr.manifest
	echo '/named/master.localhost: $${MODULE_DIR}/master.localhost' >> usr.manifest
	echo '/named/localhost.rev: $${MODULE_DIR}/localhost.rev' >> usr.manifest
	ldd named.so | grep -v linux-vdso | grep -v libdl | grep -v libpthread | \
		grep -v libz | grep -v libm | grep -v libc.so | grep -v ld-linux | \
		sed 's/ *[^ ] *\(.*\) => \(.*\) .*/\/usr\/lib\/\1: \2/' >> usr.manifest
	for f in /usr/lib/engines/*.so; do echo "$$f: $$f" >> usr.manifest; done

clean:
	rm -rf bind-9.10.1 bind-9.10.1.tar.gz named.so usr.manifest
