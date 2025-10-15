FROM t-ctr.otvl.org/cs-python:4.104.1-p1

# Install PyTorch with pip (https://pytorch.org/get-started/locally/)
RUN pip install --no-cache-dir --index-url https://download.pytorch.org/whl/cu130 \
    'torch' \
    'torchaudio' \
    'torchvision'

# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/docker-specialized.html#dockerfiles
ENV NVIDIA_VISIBLE_DEVICES="all" \
    NVIDIA_DRIVER_CAPABILITIES="compute,utility"

# Puts the nvidia-smi binary (system management interface) on path
# with associated library files to execute it
ENV PATH="${PATH}:/usr/local/nvidia/bin" \
    LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/nvidia/lib64"
