# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion autotools

DESCRIPTION="GTK frontend for X Neural Switcher"
HOMEPAGE="http://xneur.ru"
ESVN_REPO_URI="svn://xneur.ru:3690/xneur/gxneur"
ESVN_BOOTSTRAP="autopoint --force && eautoreconf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"
IUSE=""

RDEPEND="
	>=x11-libs/gtk+-2
	=x11-misc/xneur-${PV}*
"
DEPEND="
	${RDEPEND}
	sys-devel/gettext
"

src_compile() {
	econf || die
	emake CFLAGS="${CFLAGS} -std=gnu99" || die
}

src_install () {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog NEWS
}