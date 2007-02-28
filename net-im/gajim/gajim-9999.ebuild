# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/gajim/gajim-0.9.1.ebuild,v 1.1 2005/12/27 17:46:46 svyatogor Exp $

inherit subversion autotools

DESCRIPTION="Jabber client written in PyGTK"
HOMEPAGE="http://www.gajim.org/"
ESVN_REPO_URI="svn://svn.gajim.org/gajim/trunk"
ESVN_PATCHES="${PN}-*.diff"
ESVN_BOOTSTRAP="./autogen.sh && eautoreconf"
AT_M4DIR="m4"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="dbus nls spell xscreensaver trayicon ssl gnome avahi srv libnotify"

DEPEND="
	>=virtual/python-2.4
	|| (
		( <virtual/python-2.5 >=dev-python/pysqlite-2.0.4 )
		>=dev-lang/python-2.5
	)
	>=dev-python/pygtk-2.6
	!gnome? ( spell? ( >=app-text/gtkspell-2.0.4 ) )
	xscreensaver? ( x11-libs/libXScrnSaver )
"
RDEPEND="
	${DEPEND}
	dbus? (
		dev-libs/dbus-glib
		dev-python/dbus-python
	)
	ssl? ( dev-python/pyopenssl )
	gnome? (
		dev-python/gnome-python-extras
		dev-python/gnome-python-desktop
	)
	avahi? (
		net-dns/avahi
		dev-libs/dbus-glib
	)
	srv? ( net-dns/bind-tools )
	libnotify? (
		|| (
			( dev-python/notify-python dev-python/dbus-python )
			x11-misc/notification-daemon
		)
	)
"
DEPEND="
	${DEPEND}
	dev-util/intltool
	dev-util/pkgconfig
"

src_compile() {
	econf \
		$(use_enable nls) \
		$(use_enable dbus remote) \
		$(use_enable spell gtkspell) \
		$(use_enable xscreensaver idle) \
		$(use_enable trayicon) \
	|| die
	emake || die
}

src_install() {
	einstall || die
	rm -rf ${D}usr/share/doc
	dodoc README AUTHORS COPYING ChangeLog
	dohtml README.html
}