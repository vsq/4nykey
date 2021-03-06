# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )
PYTHON_REQ_USE="xml(+)"
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="4333ede"
	[[ -n ${PV%%*_p*} ]] && MY_PV="${PV}"
	SRC_URI="
		mirror://githubcl/${PN}/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="An ufo3 font editor"
HOMEPAGE="http://trufont.github.io/"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/defconQt[${PYTHON_USEDEP}]
	dev-python/extractor[${PYTHON_USEDEP}]
	dev-python/ufo2ft[${PYTHON_USEDEP}]
	dev-python/booleanOperations[${PYTHON_USEDEP}]
	dev-python/hsluv[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

src_prepare() {
	default
	# no egg-info for PyQt5
	sed -e '/\<pyqt5\>/d' -i setup.py
}
