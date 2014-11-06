
.PHONY: module
module: named.so usr.manifest

named.so:
	make -C bind-9.10.1
	cp bind-9.10.1/bin/named/named named.so

usr.manifest: named.so
	echo '[manifest]' > usr.manifest
	echo '/named/named.so: ${MODULE_DIR}/named.so' >> usr.manifest
	echo '/named/named.conf: ${MODULE_DIR}/named.conf' >> usr.manifest
	ldd named.so | grep -v linux-vdso | grep -v libdl | grep -v libpthread | \
		grep -v libz | grep -v libm | grep -v libc | grep -v ld-linux | \
		sed 's/ *[^ ] *\(.*\) => \(.*\) .*/\/usr\/lib\/\1: \2/' >> usr.manifest
