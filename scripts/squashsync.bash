#!/usr/bin/env bash

mapfile -t repolist < <(portageq repos_config / | awk '/^location = / {sub(/location *= */, ""); print}')

# mount all squashed repos
if [[ "$1" == "--init" ]]
then
	for repo in ${repolist[@]}
	do
		mount -t squashfs -o 'ro,noauto,x-systemd.automount' "${repo}.sqfs" "${repo}"
	done
	exit 0
fi


# unmount the repos and unsquash them to tmpfs
for repo in "${repolist[@]}"
do
	umount "${repo}"
	mount -t tmpfs tmpfs "${repo}"
	unsquashfs -f -d "${repo}" "${repo}.sqfs"
done

# sync repos on tmpfs
emerge --sync

# squash updated repos and remount them
for repo in ${repolist[@]}
do
	mksquashfs "${repo}" "${repo}.sqfs" -noappend
	umount "${repo}"
	mount -t squashfs -o 'ro,noauto,x-systemd.automount' "${repo}.sqfs" "${repo}"
done
