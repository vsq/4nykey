# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Aseman-Land/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="v${PV}-stable"
	SRC_URI="
		mirror://githubcl/Aseman-Land/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi
inherit qmake-utils

DESCRIPTION="A fork of libqtelegram by Aseman Team"
HOMEPAGE="https://github.com/Aseman-Land/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	dev-libs/openssl:0
	dev-qt/qtmultimedia:5
"
RDEPEND="${DEPEND}"

src_configure() {
	local _g="libqtelegram-generator"
	sed \
		-e 's:\$ASEMAN_SRC_PATH:"${S}":g' \
		-e "s:\./${_g}:\"${S}\"/${_g}:" \
		-ne "/${_g}/p" \
		-i "${S}"/init
	eqmake5 "${S}"/libqtelegram-code-generator

	ebegin "Building ${_g}"
	make ${MAKE_OPTS} >& "${T}"/${_g}.log
	eend $? || die "failed to build ${_g}, see ${T}/${_g}.log"
	ebegin "Running ${_g}"
	source "${S}"/init
	eend $? || die

	eqmake5 CONFIG+=typeobjects
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
