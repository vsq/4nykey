# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://bitbucket.org/${PN%%-*}/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="da5ac31"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		https://bitbucket.org/${PN%%-*}/${PN}/get/${MY_PV}.tar.bz2
		-> ${P}.tar.bz2
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Sorts Mill Core Library"
HOMEPAGE="https://bitbucket.org/${PN%%-*}/${PN}"

LICENSE="GPL-3"
SLOT="0"
IUSE="+atomic-ops"

RDEPEND=""
DEPEND="
	${RDEPEND}
	dev-libs/boehm-gc
	dev-libs/libunistring
	dev-libs/gmp:0
	dev-libs/libpcre
	atomic-ops? ( dev-libs/libatomic_ops )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with atomic-ops)
		--without-ats
	)
	econf "${myeconfargs[@]}"
}
