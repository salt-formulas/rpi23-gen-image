#
# Setup Salt minion
#

# Load utility functions
. ./functions.sh

# Install Salt minion
if [ "$ENABLE_SALT" = true ] ; then
  chroot_exec mkdir -p "${ETC_DIR}/apt/sources.list.d"
  echo "deb http://repo.saltstack.com/apt/debian/8/armhf/${SALT_VERSION} jessie main" >> "${ETC_DIR}/apt/sources.list.d/saltstack.list"

  wget -O - "https://repo.saltstack.com/apt/debian/8/armhf/${SALT_VERSION}/SALTSTACK-GPG-KEY.pub" | chroot_exec apt-key add -

  chroot_exec apt-get -qq -y update
  chroot_exec apt-get -qq -y install salt-minion
fi

# Configure Salt minion
if [ "$CONFIGURE_SALT" = true ] ; then
  echo "id: ${SALT_MINION}" >> "${ETC_DIR}/salt/minion.d/minion.conf"
  echo "master: ${SALT_MASTER}" >> "${ETC_DIR}/salt/minion.d/minion.conf"
fi

# Seed Salt minion keys
if [ "$SEED_SALT" = true ] ; then
  echo "${SALT_PUBLIC_KEY}" >> "${ETC_DIR}/salt/pki/minion/minion.pub"
  echo "${SALT_PRIVATE_KEY}" >> "${ETC_DIR}/salt/pki/minion/minion.pem"
fi
