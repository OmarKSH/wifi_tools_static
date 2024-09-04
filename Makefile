.PHONY: all clean iw wpa_supplicant

all: iw wpa_supplicant

openssl:
	./build_openssl.sh

iw:	
	./build_iw.sh

wpa_supplicant:
	./build_wpas.sh

clean:
	rm -rf *.tar.gz *.tar.xz prefix/ binaries/ openssl-1.1.1g/ iw-*/ wpa_supplicant-*/
