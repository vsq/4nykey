# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools ltprune
if [[ -z ${PV%%*9999} ]]; then
	EGIT_REPO_URI="https://github.com/sass/${PN}.git"
	inherit git-r3
else
	inherit vcs-snapshot
	MY_PV="946ef49"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/sass/${PN}/tar.gz/${PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A C/C++ implementation of a Sass compiler"
HOMEPAGE="https://github.com/sass/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE="static-libs"

RDEPEND=""
DEPEND="
	${RDEPEND}
"
DOCS=( {Readme,SECURITY}.md )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
