FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install build tools and core dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    pkg-config \
    # Core runtime dependencies
    libboost-all-dev \
    libspdlog-dev \
    libgmp-dev \
    libvolk2-dev \
    # Python support
    python3-dev \
    python3-pip \
    python3-numpy \
    python3-pybind11 \
    pybind11-dev \
    python3-packaging \
    python3-mako \
    python3-yaml \
    python3-click \
    python3-click-plugins \
    python3-pygccxml \
    # FFT support
    libfftw3-dev \
    # Audio support
    libasound2-dev \
    libportaudio2 \
    portaudio19-dev \
    libjack-jackd2-dev \
    # Qt GUI support
    qtbase5-dev \
    qttools5-dev \
    libqt5svg5-dev \
    libqwt-qt5-dev \
    python3-pyqt5 \
    # SDL video support
    libsdl1.2-dev \
    # ZeroMQ support
    libzmq3-dev \
    python3-zmq \
    # Codec/vocoder support
    libcodec2-dev \
    libgsm1-dev \
    # Wavelet support
    libgsl-dev \
    # Sndfile for wav files
    libsndfile1-dev \
    # UHD (USRP) support
    libuhd-dev \
    uhd-host \
    # SoapySDR support
    libsoapysdr-dev \
    soapysdr-module-rtlsdr \
    # RTL-SDR support
    rtl-sdr \
    librtlsdr-dev \
    # IIO (PlutoSDR) support
    libiio-dev \
    libad9361-dev \
    # Documentation
    doxygen \
    graphviz \
    # Testing
    python3-pytest \
    && rm -rf /var/lib/apt/lists/*

# Install additional Python packages
RUN pip3 install --no-cache-dir \
    sphinx \
    lxml \
    pyqt5 \
    QDarkStyle \
    qtpy

# Install Node.js and Claude Code
RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g @anthropic-ai/claude-code && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /src/gnuradio

CMD ["/bin/bash"]
