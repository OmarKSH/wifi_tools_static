.PHONY: all clean iw wpa_supplicant hostapd

all: iw wpa_supplicant hostapd

openssl:
	./build_openssl.sh

iw:	
	./build_iw.sh

wpa_supplicant:
	./build_wpas.sh

hostapd:
	./build_hostapd.sh

clean:
	rm -rf *.tar.gz *.tar.xz prefix/ binaries/ openssl-1.1.1g/ iw-*/ wpa_supplicant-*/ hostapd-*/
