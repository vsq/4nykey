# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit cmake-utils unpacker
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/open-eid/${PN}.git"
else
	MY_PV="${PV/_/-}"
	MY_PV="${MY_PV/rc/RC}"
	SRC_URI="
		https://codeload.github.com/open-eid/${PN}/tar.gz/v${MY_PV}
		-> ${P}.tar.gz
	"
	# submodules not included in github releases
	MY_QC="qt-common-93208c5842f37c74222d92ed5b12cfaa8eb3466b"
	MY_GB="google-breakpad-f907c96df0863eb852fe55668932c2a146c6900c"
	MY_SC="smartcardpp-9a506a0d69f00d5970cf5c213bc23547687104ab"
	SRC_URI="${SRC_URI}
		https://codeload.github.com/open-eid/${MY_QC%-*}/zip/${MY_QC##*-}
		-> ${MY_QC}.zip
		https://codeload.github.com/open-eid/${MY_GB%-*}/zip/${MY_GB##*-}
		-> ${MY_GB}.zip
		https://codeload.github.com/open-eid/${MY_SC%-*}/zip/${MY_SC##*-}
		-> ${MY_SC}.zip
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi


DESCRIPTION="Smart card manager UI application"
HOMEPAGE="http://id.ee"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="c++0x +qt5"

RDEPEND="
	sys-apps/pcsc-lite
	dev-libs/opensc
	qt5? (
		dev-qt/linguist-tools:5
		dev-qt/qtwidgets:5
		dev-qt/qtnetwork:5
	)
	!qt5? (
		dev-qt/qtcore:4[ssl]
		dev-qt/qtgui:4
		dev-qt/qtwebkit:4
	)
"
DEPEND="
	${RDEPEND}
	$(unpacker_src_uri_depends)
	dev-util/cmake-openeid
"

src_prepare() {
	if [[ -n ${PV%%*9999} ]]; then
		mv "${WORKDIR}"/${MY_GB}/* "${WORKDIR}"/${MY_QC}/${MY_GB%-*}/
		mv "${WORKDIR}"/${MY_QC}/* "${S}"/common/
		mv "${WORKDIR}"/${MY_SC}/* "${S}"/${MY_SC%-*}/
	fi
	sed \
		-e "s:doc/${PN}:doc/${PF}:" \
		-e 's:\${CMAKE_SOURCE_DIR}/cmake/modules:/usr/share/cmake/openeid:' \
		-i CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs="
		${mycmakeargs}
		$(cmake-utils_useno c++0x DISABLE_CXX11)
		$(cmake-utils_use_find_package qt5 Qt5Widgets)
	"
	cmake-utils_src_configure
}
