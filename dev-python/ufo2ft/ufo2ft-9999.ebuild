# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/googlei18n/${PN}.git"
else
	inherit vcs-snapshot
	MY_PV="9e0b45e"
	SRC_URI="
		mirror://githubcl/googlei18n/${PN}/tar.gz/${MY_PV} -> ${P}.tar.gz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A bridge from UFOs to FontTool objects"
HOMEPAGE="https://github.com/googlei18n/${PN}"

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="
	>dev-python/fonttools-3.0
	dev-python/feaTools
	dev-python/compreffor
"
RDEPEND="${DEPEND}"