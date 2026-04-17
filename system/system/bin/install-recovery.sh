#!/system/bin/sh
if ! applypatch -c EMMC:/dev/block/recovery:33554432:9abc87874e478b646d4ce46597dc90f24f16055e; then
  applypatch  EMMC:/dev/block/boot:33554432:ff7efac010e1983c704f33a400b9a749164679df EMMC:/dev/block/recovery 9abc87874e478b646d4ce46597dc90f24f16055e 33554432 ff7efac010e1983c704f33a400b9a749164679df:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
else
  log -t recovery "Recovery image already installed"
fi
