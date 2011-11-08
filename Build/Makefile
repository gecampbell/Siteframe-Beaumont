# $Id: Makefile,v 1.17 2006/01/14 00:00:25 glen Exp $
# Makefile for Siteframe Beaumont (v5.x)

all:	beaumont.tar beaumont.zip
	mv beaumont.tar siteframe-`./get_version.sh`-`cat build.dat`.tar; \
	gzip siteframe*.tar; \
	mv beaumont.zip siteframe-`./get_version.sh`-`cat build.dat`.zip; \
	rm -rf beaumont

beaumont.tar: beaumont
	./get_version.sh; \
	cd beaumont; \
	tar cvf ../beaumont.tar \
	`find . -type f|grep -v CVS|grep -v files/compile|grep -v Build`; 

beaumont.zip: beaumont
	find beaumont -type f|grep -v CVS|grep -v files/compile|grep -v Build|zip beaumont -@;

beaumont:
	./increment_build.sh ; \
	cvs co beaumont; \
	perl -p -i -e "s/%%VERSION%%/`./get_version.sh`/;" beaumont/siteframe.inc beaumont/README.txt ; \
	perl -p -i -e "s/%%BUILD%%/`cat build.dat`/;" beaumont/siteframe.inc beaumont/README.txt

clean:
	rm -rf beaumont siteframe*.tar.gz siteframe*.zip

