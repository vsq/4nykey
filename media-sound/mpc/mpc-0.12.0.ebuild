# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mpc/mpc-0.11.1.ebuild,v 1.5 2004/10/20 05:51:08 eradicator Exp $

inherit subversion autotools bash-completion

DESCRIPTION="A commandline client for Music Player Daemon (media-sound/mpd)"
HOMEPAGE="http://www.musicpd.org"
#SRC_URI="mirror://sourceforge/musicpd/${P}.tar.gz"
ESVN_REPO_URI="https://svn.musicpd.org/${PN}/trunk"

IUSE="nls"
KEYWORDS="~x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/libc
	nls? ( || ( sys-libs/glibc dev-libs/libiconv ) )"

src_unpack() {
	subversion_src_unpack
	cd ${S}
	eautoreconf || die
}

src_compile() {
	econf --disable-dependency-tracking \
		$(use_enable nls iconv) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die
	mv ${D}/usr/share/doc/mpc/ ${D}/usr/share/doc/${PF}
	dobashcompletion doc/mpc-bashrc
}
