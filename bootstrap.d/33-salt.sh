#
# Setup Salt minion
#

# Load utility functions
. ./functions.sh

# Install Salt minion
if [ "$ENABLE_SALT" = true ] ; then
  mkdir -p "${ETC_DIR}/apt/sources.list.d"
  printf "deb http://repo.saltstack.com/apt/debian/8/armhf/${SALT_VERSION} jessie main" >> "${ETC_DIR}/apt/sources.list.d/saltstack.list"

  wget -O - "https://repo.saltstack.com/apt/debian/8/armhf/${SALT_VERSION}/SALTSTACK-GPG-KEY.pub" | chroot_exec apt-key add -

  chroot_exec apt-get -qq -y update
  chroot_exec apt-get -qq -y install salt-minion

  # Configure Salt minion
  if [ "$CONFIGURE_SALT" = true ] ; then
    printf "id: ${SALT_MINION}" >> "${ETC_DIR}/salt/minion.d/minion.conf"
    printf "\nmaster: ${SALT_MASTER}" >> "${ETC_DIR}/salt/minion.d/minion.conf"
  fi

  # Preseed Salt minion keys
  if [ "$PRESEED_SALT" = true ] ; then
    mkdir -p "${ETC_DIR}/salt/pki/minion"
    printf "${SALT_PUB_KEY}" >> "${ETC_DIR}/salt/pki/minion/minion.pub"
    printf "${SALT_PRIV_KEY}" >> "${ETC_DIR}/salt/pki/minion/minion.pem"
  fi

fi
