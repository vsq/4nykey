# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_MAX_API_VERSION="0.34"
inherit eutils pax-utils vala gnome2 cmake-utils

if [[ -z ${PV%%*9999} ]]; then
	EBZR_REPO_URI="lp:~${PN}/${PN}/snapcraft"
	inherit bzr
	SRC_URI=
else
	SRC_URI="
		http://www.${PN}-browser.org/downloads/${PN}_${PV}_all_.tar.bz2
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A lightweight web browser based on WebKitGTK+"
HOMEPAGE="http://www.midori-browser.org/"

LICENSE="LGPL-2.1 MIT"
SLOT="0"
IUSE="apidocs granite xscreensaver +jit zeitgeist"

RDEPEND="
	>=app-crypt/gcr-3:=[gtk]
	>=dev-db/sqlite-3.6.19:3
	>=dev-libs/glib-2.32.3:2
	dev-libs/libxml2
	>=net-libs/libsoup-2.38:2.4
	>=x11-libs/libnotify-0.7
	xscreensaver? ( x11-libs/libXScrnSaver )
	>=x11-libs/gtk+-3.10.0:3
	>=net-libs/webkit-gtk-2.3.91:4[jit=]
	granite? ( >=dev-libs/granite-0.2 )
	zeitgeist? ( >=dev-libs/libzeitgeist-0.3.14 )
"
DEPEND="
	${RDEPEND}
	$(vala_depend)
	dev-util/intltool
	gnome-base/librsvg
	sys-devel/gettext
	apidocs? ( dev-util/gtk-doc )
"
PATCHES=(
	"${FILESDIR}"/${PN}_soup-gnome.diff
)

src_prepare() {
	vala_src_prepare
	cmake-utils_src_prepare
	sed -i -e '/^install/s:COPYING:HACKING TODO TRANSLATE:' CMakeLists.txt || die
}

src_configure() {
	strip-linguas -i po

	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
		-DUSE_APIDOCS=$(usex apidocs)
		-DUSE_GRANITE=$(usex granite)
		-DUSE_ZEITGEIST=$(usex zeitgeist)
		-DUSE_XSCREENSAVER=$(usex xscreensaver)
		-DVALA_EXECUTABLE=${VALAC}
		-DUSE_GTK3=ON
		-DHALF_BRO_INCOM_WEBKIT2=ON
	)
	cmake-utils_src_configure
}
