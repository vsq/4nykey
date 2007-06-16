# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs autotools

DESCRIPTION="Frame Server for Linux and Windows"
HOMEPAGE="http://avisynth2.sourceforge.net"
ECVS_SERVER="avisynth2.cvs.sourceforge.net:/cvsroot/avisynth2"
ECVS_MODULE="${PN}"
ECVS_BRANCH="avisynth_3_0"
S="${WORKDIR}/${ECVS_MODULE}/build/linux"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug doc gtk ffmpeg"

DEPEND="
	dev-libs/STLport
	>=dev-libs/boost-1.34
	>=media-libs/freetype-2
	media-libs/fontconfig
	x86? ( dev-lang/nasm )
	>=media-libs/gst-plugins-base-0.10.8
	gtk? ( >=x11-libs/gtk+-2.8 )
"
RDEPEND="
	${DEPEND}
	ffmpeg? ( >=media-plugins/gst-plugins-ffmpeg-0.10 )
"
DEPEND="
	${DEPEND}
	doc? ( app-doc/doxygen )
"

src_unpack() {
	cvs_src_unpack
	cd ${S}
	tar -xjf ../circular_buffer_v3.7.tar.bz2
	epatch "${FILESDIR}"/${PN}-*.diff
	epatch "${S}"/gentoo/files/*.patch
	mv circular_buffer boost
	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	CPPFLAGS="${CPPFLAGS} -I." \
	econf \
		$(use_enable debug core-debug) \
		$(use_enable gtk gui) \
		$(use_enable doc) \
		--with-boost-lib-name=boost_thread-mt \
		|| die
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc ../../*.txt ../../TODO
}
