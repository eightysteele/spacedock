# syntax=docker/dockerfile:1.7-labs

# Installs mlir-tools and libmlir-dev: https://apt.llvm.org

ARG LLVM_VERSION

################################################################################
FROM llvm AS mlir
################################################################################

ARG LLVM_VERSION

# ------------------------------------------------------------------------------
# mlir
# ------------------------------------------------------------------------------

RUN bash -x <<"EOF"
set -eu
apt-get update
apt-get install -y \
    libmlir-${LLVM_VERSION}-dev \
    mlir-${LLVM_VERSION}-tools
EOF

RUN bash -x <<"EOF"
set -eu
update-alternatives --install /usr/bin/mlir-cat mlir-cat /usr/lib/llvm-${LLVM_VERSION}/bin/mlir-cat 1
update-alternatives --install /usr/bin/mlir-cpu-runner mlir-cpu-runner /usr/lib/llvm-${LLVM_VERSION}/bin/mlir-cpu-runner 1
update-alternatives --install /usr/bin/mlir-linalg-ods-yaml-gen mlir-linalg-ods-yaml-gen /usr/lib/llvm-${LLVM_VERSION}/bin/mlir-linalg-ods-yaml-gen 1
update-alternatives --install /usr/bin/mlir-lsp-server mlir-lsp-server /usr/lib/llvm-${LLVM_VERSION}/bin/mlir-lsp-server 1
update-alternatives --install /usr/bin/mlir-minimal-opt mlir-minimal-opt /usr/lib/llvm-${LLVM_VERSION}/bin/mlir-minimal-opt 1
update-alternatives --install /usr/bin/mlir-minimal-opt-canonicalize mlir-minimal-opt-canonicalize /usr/lib/llvm-${LLVM_VERSION}/bin/mlir-minimal-opt-canonicalize 1
update-alternatives --install /usr/bin/mlir-opt mlir-opt /usr/lib/llvm-${LLVM_VERSION}/bin/mlir-opt 1
update-alternatives --install /usr/bin/mlir-pdll mlir-pdll /usr/lib/llvm-${LLVM_VERSION}/bin/mlir-pdll 1
update-alternatives --install /usr/bin/mlir-pdll-lsp-server mlir-pdll-lsp-server /usr/lib/llvm-${LLVM_VERSION}/bin/mlir-pdll-lsp-server 1
update-alternatives --install /usr/bin/mlir-query mlir-query /usr/lib/llvm-${LLVM_VERSION}/bin/mlir-query 1
update-alternatives --install /usr/bin/mlir-reduce mlir-reduce /usr/lib/llvm-${LLVM_VERSION}/bin/mlir-reduce 1
update-alternatives --install /usr/bin/mlir-tblgen mlir-tblgen /usr/lib/llvm-${LLVM_VERSION}/bin/mlir-tblgen 1
update-alternatives --install /usr/bin/mlir-translate mlir-translate /usr/lib/llvm-${LLVM_VERSION}/bin/mlir-translate 1
update-alternatives --install /usr/bin/clang-tblgen clang-tblgen /usr/lib/llvm-${LLVM_VERSION}/bin/clang-tblgen 1
update-alternatives --install /usr/bin/llvm-tblgen llvm-tblgen /usr/lib/llvm-${LLVM_VERSION}/bin/llvm-tblgen 1
update-alternatives --install /usr/bin/tblgen-lsp-server tblgen-lsp-server /usr/lib/llvm-${LLVM_VERSION}/bin/tblgen-lsp-server 1
update-alternatives --install /usr/bin/tblgen-to-irdl tblgen-to-irdl /usr/lib/llvm-${LLVM_VERSION}/bin/tblgen-to-irdl 1
apt-get clean
rm -rf /var/lib/apt/lists/*
EOF
