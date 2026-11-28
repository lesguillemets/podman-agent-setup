ARG FEDORA_VERSION=45
FROM quay.io/fedora/fedora:${FEDORA_VERSION}

# texlive, fonts
RUN dnf install -y texlive-scheme-full \
	google-noto-sans-cjk-fonts google-noto-serif-cjk-fonts google-noto-sans-jp-fonts \
	pandoc-cli \
	&& dnf clean all
RUN dnf install -y mrsw-biz-udgothic-fonts-all mrsw-biz-udpgothic-fonts mrsw-biz-udmincho-fonts-all mrsw-biz-udpmincho-fonts && dnf clean all

RUN dnf install -y \
	git ssh vim neovim make cmake gcc gcc-c++ clang gettext curl \
	perl nkf \
	openssl openssl-devel \
	gmp gmp-devel ncurses ncurses-compat-libs xz \
	ninja-build \
	&& dnf clean all

RUN dnf install -y \
	nkf \
	qpdf mupdf mupdf-libs \
	opencv ffmpeg \
	inkscape ImageMagick-heic libheif libheif-ffmpeg libheif-tools \
	libavif-tools \
	jq tree sqlite \
	&& dnf clean all

RUN dnf install -y \
	htop \
	ripgrep fd-find git-delta \
	hugo \
	ShellCheck \
	yt-dlp \
	&& dnf clean all

RUN dnf install -y nodejs-npm yarnpkg \
	&& dnf clean all

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
RUN uv tool install ruff
RUN uv tool install pyright

ENV PATH="/root/.cargo/bin:/root/.local/bin:${PATH}"
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o /tmp/rustup.sh \
	&& sh /tmp/rustup.sh -y --default-toolchain nightly --profile default \
	--component rustfmt,clippy \
	&& rm /tmp/rustup.sh
COPY --chown=0:0 uv.toml /etc/uv/uv.toml
RUN cargo install --locked typst-cli
RUN cargo install --locked starship

RUN curl -fsSL https://claude.ai/install.sh  -o /tmp/claude.sh \
	&& bash /tmp/claude.sh

RUN npm install --global @openai/codex@latest \
	&& npm cache clean --force

COPY --chown=0:0 gitconfig /root/.gitconfig
COPY --chown=0:0 basic_bashrc.sh /root/.bashrc
COPY --chown=0:0 editorconfig /root/.editorconfig

CMD ["/bin/bash"]
