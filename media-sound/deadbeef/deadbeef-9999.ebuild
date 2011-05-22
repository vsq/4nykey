# Copyright 2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit fdo-mime gnome2-utils flag-o-matic autotools git

EGIT_BRANCH="devel"
EGIT_COMMIT="${EGIT_BRANCH}"
EGIT_REPO_URI="git://deadbeef.git.sourceforge.net/gitroot/deadbeef/deadbeef"
EGIT_BOOTSTRAP="eautoreconf"

DESCRIPTION="DeaDBeeF - Ultimate Music Player For GNU/Linux"
HOMEPAGE="http://deadbeef.sourceforge.net/"
LICENSE="GPL-2 LGPL-2.1"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="
alsa oss pulseaudio gtk network sid mad mac adplug vorbis ffmpeg flac sndfile
wavpack cdda gme libnotify musepack midi tta dts aac mms libsamplerate X cover
zip nls threads pth gnome
"

# come bundled
RDEPEND="
	adplug? ( media-libs/adplug )
	dts? ( media-libs/libdca )
	mac? ( media-sound/mac )
	gme? ( media-libs/game-music-emu )
	mms? ( media-libs/libmms )
	sid? ( media-sound/sidplay )
	tta? ( media-sound/ttaenc )
	midi? ( media-sound/wildmidi )
"
# real deps
RDEPEND="
	alsa? ( media-libs/alsa-lib )
	ffmpeg? ( virtual/ffmpeg )
	mad? ( media-libs/libmad )
	vorbis? ( media-libs/libvorbis )
	flac? ( media-libs/flac )
	wavpack? ( media-sound/wavpack )
	sndfile? ( media-libs/libsndfile )
	network? ( net-misc/curl )
	cdda? ( dev-libs/libcdio media-libs/libcddb )
	gtk? ( x11-libs/gtk+:2 )
	X? ( x11-libs/libX11 )
	pulseaudio? ( media-sound/pulseaudio )
	cover? ( media-libs/imlib2 )
	libsamplerate? ( media-libs/libsamplerate )
	musepack? ( media-sound/musepack-tools )
	aac? ( media-libs/faad2 )
	libnotify? ( x11-libs/libnotify sys-apps/dbus )
	zip? ( sys-libs/zlib dev-libs/libzip )
	pth? ( dev-libs/pth )
	gme? ( sys-libs/zlib )
	midi? ( media-sound/timidity-freepats )
"
DEPEND="
	${RDEPEND}
	oss? ( virtual/libc )
"

src_prepare() {
	sed -i "${S}"/plugins/wildmidi/wildmidiplug.c \
		-e 's,#define DEFAULT_TIMIDITY_CONFIG ",&/usr/share/timidity/freepats/timidity.cfg:,'
	mkdir -p ${S}/m4
	git_src_prepare
}

src_configure() {
	local _thr_impl="posix"
	use pth && _thr_impl="pth"
	econf \
		$(use_enable nls) \
		$(use_enable threads threads ${_thr_impl}) \
		$(use_enable alsa) \
		$(use_enable oss) \
		$(use_enable pulseaudio pulse) \
		$(use_enable gtk gtkui) \
		$(use_enable network vfs-curl) \
		$(use_enable network lfm) \
		$(use_enable cover artwork) \
		$(use_enable sid) \
		$(use_enable mad) \
		$(use_enable mac ffap) \
		$(use_enable adplug) \
		$(use_enable X hotkeys) \
		$(use_enable vorbis) \
		$(use_enable ffmpeg) \
		$(use_enable flac) \
		$(use_enable sndfile) \
		$(use_enable wavpack) \
		$(use_enable cdda ) \
		$(use_enable gme) \
		$(use_enable libnotify notify) \
		$(use_enable musepack) \
		$(use_enable midi wildmidi) \
		$(use_enable tta) \
		$(use_enable dts dca) \
		$(use_enable aac) \
		$(use_enable mms) \
		$(use_enable libsamplerate src) \
		$(use_enable zip vfs-zip) \
		--docdir="/usr/share/doc/${PF}" \
		--disable-dependency-tracking \
		--disable-static
}

src_install() {
	emake DESTDIR="${D}" install || die
	rm -f "${D}"/usr/share/doc/${PF}/COPYING*
	rm -f "${D}"/usr/$(get_libdir)/${PN}/*.la
	prepalldocs
	dodoc AUTHORS CONTRIBUTING
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	use gtk && gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	use gtk && gnome2_icon_cache_update
}