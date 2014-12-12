# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/heuristica/heuristica-0.2.1.ebuild,v 1.1 2010/03/06 20:02:59 spatz Exp $

EAPI="3"

if [[ ${PV} == *9999* ]]; then
	inherit subversion font
	ESVN_REPO_URI="http://evristika.googlecode.com/svn/trunk"
	DEPEND="
		media-gfx/fontforge[python]
		dev-texlive/texlive-fontutils
		media-gfx/xgridfit
	"
else
	S="${WORKDIR}"
	inherit font
	SRC_URI="
		mirror://sourceforge/${PN}/${PN}-ttf-${PV}.tar.xz
		mirror://sourceforge/${PN}/${PN}-otf-${PV}.tar.xz
		mirror://sourceforge/${PN}/${PN}-pfb-${PV}.tar.xz
	"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A font based on Adobe Utopia"
HOMEPAGE="http://code.google.com/p/evristika/"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

FONT_SUFFIX="afm otf pfb ttf"
DOCS="FontLog.txt"

src_unpack() {
	if [[ ${PV} == *9999* ]]; then
		subversion_src_unpack
		ESVN_PROJECT="font-helpers" \
			subversion_fetch "http://font-helpers.googlecode.com/svn/trunk"
	fi
	default
}
