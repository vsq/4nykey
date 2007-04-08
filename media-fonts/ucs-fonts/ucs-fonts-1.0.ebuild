# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font font-ebdftopcf

DESCRIPTION="An ISO10646-1/Unicode extension to classic X bitmap fonts"
HOMEPAGE="http://www.cl.cam.ac.uk/~mgk25/ucs/ucs-fonts.html"
BASE_URI="http://www.cl.cam.ac.uk/~mgk25/download/"
SRC_URI="
	${BASEURI}/${PN}.tar.gz ${BASEURI}/ucs-lucida.tar.gz
	cjk? ( ${BASEURI}/${PN}-asian.tar.gz )
"
S="${WORKDIR}"

LICENSE="X11"
SLOT="0"
KEYWORDS="~x86"
IUSE="cjk"

DOCS="issues.txt README*"
FONT_S="${S}"
FONT_SUFFIX="pcf.gz"