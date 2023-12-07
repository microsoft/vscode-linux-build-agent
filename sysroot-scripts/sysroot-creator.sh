#!/bin/bash

# Copyright 2014 The Chromium Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

#@ This script builds Debian sysroot images for building Google Chrome.
#@
#@  Usage:
#@    sysroot-creator.sh {build} \
#@    {amd64,armhf,arm64} {install-root}
#@

######################################################################
# Config
######################################################################

set -o nounset
set -o errexit

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DISTRO=debian
RELEASE=bullseye

# This number is appended to the sysroot key to cause full rebuilds.  It
# should be incremented when removing packages or patching existing packages.
# It should not be incremented when adding packages.
SYSROOT_RELEASE=2

ARCHIVE_TIMESTAMP=20230611T210420Z

ARCHIVE_URL="https://snapshot.debian.org/archive/debian/$ARCHIVE_TIMESTAMP/"
APT_SOURCES_LIST=(
  # Debian 12 (Bookworm) is needed for GTK4.  It should be kept before bullseye
  # so that bullseye takes precedence.
  "${ARCHIVE_URL} bookworm main"
  "${ARCHIVE_URL} bookworm-updates main"

  # This mimics a sources.list from bullseye.
  "${ARCHIVE_URL} bullseye main contrib non-free"
  "${ARCHIVE_URL} bullseye-updates main contrib non-free"
  "${ARCHIVE_URL} bullseye-backports main contrib non-free"
)

# gpg keyring file generated using generate_keyring.sh
KEYRING_FILE="${SCRIPT_DIR}/keyring.gpg"

# Sysroot packages: these are the packages needed to build VSCode.
DEBIAN_PACKAGES="\
  comerr-dev
  krb5-multidev
  libbsd0
  libcom-err2
  libgssapi-krb5-2
  libgssrpc4
  libk5crypto3
  libkadm5clnt-mit12
  libkadm5srv-mit12
  libkdb5-10
  libkeyutils1
  libkrb5-3
  libkrb5-dev
  libkrb5support0
  liblzma5
  libmd0
  libpcre2-8-0
  libselinux1
  libssl-dev
  libssl1.1
  libtirpc3
  libx11-6
  libx11-dev
  libxau-dev
  libxau6
  libxcb1
  libxcb1-dev
  libxdmcp-dev
  libxdmcp6
  libxkbfile1
  libxkbfile-dev
  libzstd1
  x11proto-dev
  zlib1g
  zlib1g-dev
"

DEBIAN_PACKAGES_AMD64="
"

DEBIAN_PACKAGES_I386="
"

DEBIAN_PACKAGES_ARMHF="
"

DEBIAN_PACKAGES_ARM64="
"

DEBIAN_PACKAGES_ARMEL="
"

DEBIAN_PACKAGES_MIPSEL="
"

DEBIAN_PACKAGES_MIPS64EL="
"

readonly REQUIRED_TOOLS="curl xzcat"

######################################################################
# Package Config
######################################################################

readonly PACKAGES_EXT=xz
readonly RELEASE_FILE="Release"
readonly RELEASE_FILE_GPG="Release.gpg"

######################################################################
# Helper
######################################################################

Banner() {
  echo "######################################################################"
  echo $*
  echo "######################################################################"
}


SubBanner() {
  echo "----------------------------------------------------------------------"
  echo $*
  echo "----------------------------------------------------------------------"
}


Usage() {
  egrep "^#@" "${BASH_SOURCE[0]}" | cut --bytes=3-
}


DownloadOrCopyNonUniqueFilename() {
  # Use this function instead of DownloadOrCopy when the url uniquely
  # identifies the file, but the filename (excluding the directory)
  # does not.
  local url="$1"
  local dest="$2"

  local hash="$(echo "$url" | sha256sum | cut -d' ' -f1)"

  DownloadOrCopy "${url}" "${dest}.${hash}"
  # cp the file to prevent having to redownload it, but mv it to the
  # final location so that it's atomic.
  cp "${dest}.${hash}" "${dest}.$$"
  mv "${dest}.$$" "${dest}"
}

DownloadOrCopy() {
  if [ -f "$2" ] ; then
    echo "$2 already in place"
    return
  fi

  HTTP=0
  echo "$1" | grep -Eqs '^https?://' && HTTP=1
  if [ "$HTTP" = "1" ]; then
    SubBanner "downloading from $1 -> $2"
    # Appending the "$$" shell pid is necessary here to prevent concurrent
    # instances of sysroot-creator.sh from trying to write to the same file.
    local temp_file="${2}.partial.$$"
    # curl --retry doesn't retry when the page gives a 4XX error, so we need to
    # manually rerun.
    for i in {1..10}; do
      # --create-dirs is added in case there are slashes in the filename, as can
      # happen with the "debian/security" release class.
      local http_code=$(curl -L "$1" --create-dirs -o "${temp_file}" \
                        -w "%{http_code}")
      if [ ${http_code} -eq 200 ]; then
        break
      fi
      echo "Bad HTTP code ${http_code} when downloading $1"
      rm -f "${temp_file}"
      sleep $i
    done
    if [ ! -f "${temp_file}" ]; then
      exit 1
    fi
    mv "${temp_file}" $2
  else
    SubBanner "copying from $1"
    cp "$1" "$2"
  fi
}

SetEnvironmentVariables() {
  case $ARCH in
    amd64)
      TRIPLE=x86_64-linux-gnu
      DEBIAN_PACKAGES_ARCH="${DEBIAN_PACKAGES_AMD64}"
      ;;
    armhf)
      TRIPLE=arm-linux-gnueabihf
      DEBIAN_PACKAGES_ARCH="${DEBIAN_PACKAGES_ARMHF}"
      ;;
    arm64)
      TRIPLE=aarch64-linux-gnu
      DEBIAN_PACKAGES_ARCH="${DEBIAN_PACKAGES_ARM64}"
      ;;
    *)
      echo "ERROR: Unsupported architecture: $ARCH"
      Usage
      exit 1
      ;;
  esac
}

# some sanity checks to make sure this script is run from the right place
# with the right tools
SanityCheck() {
  Banner "Sanity Checks"

  BUILD_DIR="${SCRIPT_DIR}/out/sysroot-build/${RELEASE}"
  mkdir -p ${BUILD_DIR}
  echo "Using build directory: ${BUILD_DIR}"

  for tool in ${REQUIRED_TOOLS} ; do
    if ! which ${tool} > /dev/null ; then
      echo "Required binary $tool not found."
      echo "Exiting."
      exit 1
    fi
  done

  if ! mkdir -p "${INSTALL_ROOT}" ; then
    echo "ERROR: ${INSTALL_ROOT} can't be created."
    exit 1
  fi
}


ChangeDirectory() {
  # Change directory to where this script is.
  cd ${SCRIPT_DIR}
}

ExtractPackageXz() {
  local src_file="$1"
  local dst_file="$2"
  local repo="$3"
  xzcat "${src_file}" | egrep '^(Package:|Filename:|SHA256:) ' |
    sed "s|Filename: |Filename: ${repo}|" > "${dst_file}"
}

GeneratePackageListDistRepo() {
  local arch="$1"
  local repo="$2"
  local dist="$3"
  local repo_name="$4"

  local tmp_package_list="${BUILD_DIR}/Packages.${dist}_${repo_name}_${arch}"
  local repo_basedir="${repo}/dists/${dist}"
  local package_list="${BUILD_DIR}/Packages.${dist}_${repo_name}_${arch}.${PACKAGES_EXT}"
  local package_file_arch="${repo_name}/binary-${arch}/Packages.${PACKAGES_EXT}"
  local package_list_arch="${repo_basedir}/${package_file_arch}"

  DownloadOrCopyNonUniqueFilename "${package_list_arch}" "${package_list}"
  VerifyPackageListing "${package_file_arch}" "${package_list}" ${repo} ${dist}
  ExtractPackageXz "${package_list}" "${tmp_package_list}" ${repo}
  cat "${tmp_package_list}" | ./merge-package-lists.py "${list_base}"
}

GeneratePackageListDist() {
  local arch="$1"
  set -- $2
  local repo="$1"
  local dist="$2"
  shift 2
  while (( "$#" )); do
    GeneratePackageListDistRepo "$arch" "$repo" "$dist" "$1"
    shift
  done
}

GeneratePackageList() {
  local output_file="$1"
  local arch="$2"
  local packages="$3"

  local list_base="${BUILD_DIR}/Packages.${RELEASE}_${arch}"
  > "${list_base}"  # Create (or truncate) a zero-length file.
  printf '%s\n' "${APT_SOURCES_LIST[@]}" | while read source; do
    GeneratePackageListDist "${arch}" "${source}"
  done

  GeneratePackageListImpl "${list_base}" "${output_file}" \
    "${DEBIAN_PACKAGES} ${packages}"
}

StripChecksumsFromPackageList() {
  local package_file="$1"
  sed -i 's/ [a-f0-9]\{64\}$//' "$package_file"
}

######################################################################
#
######################################################################

InstallIntoSysroot() {
  Banner "Install Libs And Headers Into Jail"

  mkdir -p ${BUILD_DIR}/debian-packages
  # The /debian directory is an implementation detail that's used to cd into
  # when running dpkg-shlibdeps.
  mkdir -p ${INSTALL_ROOT}/debian
  # An empty control file is necessary to run dpkg-shlibdeps.
  touch ${INSTALL_ROOT}/debian/control
  while (( "$#" )); do
    local file="$1"
    local package="${BUILD_DIR}/debian-packages/${file##*/}"
    shift
    local sha256sum="$1"
    shift
    if [ "${#sha256sum}" -ne "64" ]; then
      echo "Bad sha256sum from package list"
      exit 1
    fi

    Banner "Installing $(basename ${file})"
    DownloadOrCopy ${file} ${package}
    if [ ! -s "${package}" ] ; then
      echo
      echo "ERROR: bad package ${package}"
      exit 1
    fi
    echo "${sha256sum}  ${package}" | sha256sum --quiet -c

    SubBanner "Extracting to ${INSTALL_ROOT}"
    dpkg-deb -x ${package} ${INSTALL_ROOT}

    base_package=$(dpkg-deb --field ${package} Package)
    mkdir -p ${INSTALL_ROOT}/debian/${base_package}/DEBIAN
    dpkg-deb -e ${package} ${INSTALL_ROOT}/debian/${base_package}/DEBIAN
  done

  # Prune /usr/share, leaving only pkgconfig, wayland, and wayland-protocols.
  ls -d ${INSTALL_ROOT}/usr/share/* | \
    grep -v "/\(pkgconfig\|wayland\|wayland-protocols\)$" | xargs rm -r
}


CleanupJailSymlinks() {
  Banner "Jail symlink cleanup"

  SAVEDPWD=$(pwd)
  cd ${INSTALL_ROOT}
  local libdirs="lib/${TRIPLE} usr/lib/${TRIPLE}"
  if [ -d lib64 ]; then
    libdirs="${libdirs} lib64/${TRIPLE}"
  fi

  find $libdirs -type l -printf '%p %l\n' | while read link target; do
    # skip links with non-absolute paths
    echo "${target}" | grep -qs ^/ || continue
    echo "${link}: ${target}"
    # Relativize the symlink.
    prefix=$(echo "${link}" | sed -e 's/[^/]//g' | sed -e 's|/|../|g')
    ln -snfv "${prefix}${target}" "${link}"
  done

  failed=0
  while read link target; do
    # Make sure we catch new bad links.
    if [ ! -r "${link}" ]; then
      echo "ERROR: FOUND BAD LINK ${link}"
      ls -l ${link}
      failed=1
    fi
  done < <(find $libdirs -type l -printf '%p %l\n')
  if [ $failed -eq 1 ]; then
      exit 1
  fi
  cd "$SAVEDPWD"
}


VerifyLibraryDeps() {
  Banner "Verify missing deps"

  local find_dirs=(
    "${INSTALL_ROOT}/lib/"
    "${INSTALL_ROOT}/lib/${TRIPLE}/"
    "${INSTALL_ROOT}/usr/lib/${TRIPLE}/"
  )
  local needed_libs="$(
    find ${find_dirs[*]} -name "*\.so*" -type f -exec file {} \; | \
      grep ': ELF' | sed 's/^\(.*\): .*$/\1/' | xargs readelf -d | \
      grep NEEDED | sort | uniq | sed 's/^.*Shared library: \[\(.*\)\]$/\1/g')"
  local all_libs="$(find ${find_dirs[*]} -printf '%f\n')"
  # Ignore missing libdbus-1.so.0
  all_libs+="$(echo -e '\nlibdbus-1.so.0')"
  local missing_libs="$(grep -vFxf <(echo "${all_libs}") \
    <(echo "${needed_libs}"))"
  if [ ! -z "${missing_libs}" ]; then
    echo "Missing libraries:"
    echo "${missing_libs}"
    exit 1
  fi
}

BuildSysroot() {
  local package_file="generated_package_lists/${RELEASE}.${ARCH}"
  GeneratePackageList "${package_file}" $ARCH "${DEBIAN_PACKAGES_ARCH}"
  local files_and_sha256sums="$(cat ${package_file})"
  StripChecksumsFromPackageList "$package_file"
  InstallIntoSysroot ${files_and_sha256sums}
  CleanupJailSymlinks
  VerifyLibraryDeps
}

#
# CheckForDebianGPGKeyring
#
#     Make sure the Debian GPG keys exist. Otherwise print a helpful message.
#
CheckForDebianGPGKeyring() {
  if [ ! -e "$KEYRING_FILE" ]; then
    echo "KEYRING_FILE not found: ${KEYRING_FILE}"
    echo "Debian GPG keys missing. Install the debian-archive-keyring package."
    exit 1
  fi
}

#
# VerifyPackageListing
#
#     Verifies the downloaded Packages.xz file has the right checksums.
#
VerifyPackageListing() {
  local file_path="$1"
  local output_file="$2"
  local repo="$3"
  local dist="$4"

  local repo_basedir="${repo}/dists/${dist}"
  local release_list="${repo_basedir}/${RELEASE_FILE}"
  local release_list_gpg="${repo_basedir}/${RELEASE_FILE_GPG}"

  local release_file="${BUILD_DIR}/${dist}-${RELEASE_FILE}"
  local release_file_gpg="${BUILD_DIR}/${dist}-${RELEASE_FILE_GPG}"

  CheckForDebianGPGKeyring

  DownloadOrCopyNonUniqueFilename ${release_list} ${release_file}
  DownloadOrCopyNonUniqueFilename ${release_list_gpg} ${release_file_gpg}
  echo "Verifying: ${release_file} with ${release_file_gpg}"
  set -x
  gpgv --keyring "${KEYRING_FILE}" "${release_file_gpg}" "${release_file}"
  set +x

  echo "Verifying: ${output_file}"
  local sha256sum=$(grep -E "${file_path}\$|:\$" "${release_file}" | \
    grep "SHA256:" -A 1 | xargs echo | awk '{print $2;}')

  if [ "${#sha256sum}" -ne "64" ]; then
    echo "Bad sha256sum from ${release_list}"
    exit 1
  fi

  echo "${sha256sum}  ${output_file}" | sha256sum --quiet -c
}

#
# GeneratePackageListImpl
#
#     Looks up package names in ${BUILD_DIR}/Packages and write list of URLs
#     to output file.
#
GeneratePackageListImpl() {
  local input_file="$1"
  local output_file="$2"
  echo "Updating: ${output_file} from ${input_file}"
  /bin/rm -f "${output_file}"
  shift
  shift
  local failed=0
  for pkg in $@ ; do
    local pkg_full=$(grep -A 1 " ${pkg}\$" "$input_file" | \
      egrep "pool/.*" | sed 's/.*Filename: //')
    if [ -z "${pkg_full}" ]; then
      echo "ERROR: missing package: $pkg"
      local failed=1
    else
      local sha256sum=$(grep -A 4 " ${pkg}\$" "$input_file" | \
        grep ^SHA256: | sed 's/^SHA256: //')
      if [ "${#sha256sum}" -ne "64" ]; then
        echo "Bad sha256sum from Packages"
        local failed=1
      fi
      echo $pkg_full $sha256sum >> "$output_file"
    fi
  done
  if [ $failed -eq 1 ]; then
    exit 1
  fi
  # sort -o does an in-place sort of this file
  sort "$output_file" -o "$output_file"
}

if [ $# -ne 3 ]; then
  Usage
  exit 1
else
  ChangeDirectory
  ARCH=$2
  INSTALL_ROOT=$3
  SetEnvironmentVariables
  SanityCheck
  case "$1" in
    build)
      BuildSysroot
      ;;
    *)
      echo "ERROR: Invalid command: $1"
      Usage
      exit 1
      ;;
  esac
fi
