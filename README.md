nvim-lsp-installer test
========

Test image for validating https://github.com/williamboman/nvim-lsp-installer/issues/412

Expected behaviour:
```bash
$ docker build . -t nvim-test
$ docker run --rm -ti nvim-test bash
>> nvim   # auto install packer
:q
>> nvim
:PackerInstall   # install packages
:q
>> nvim
:LspInstallInfo   # verify that pyright sumneko_lua are installing
:q
>> ls -l .local/share/nvim/lsp_servers/python
drwxr-xr-x 4 testuser testuser 4096 Jan 14 15:55 node_modules
-rw-r--r-- 1 testuser testuser  188 Jan 14 15:55 nvim-lsp-installer-receipt.json
-rw-r--r-- 1 testuser testuser  291 Jan 14 15:55 package.json
-rw-r--r-- 1 testuser testuser  380 Jan 14 15:55 package-lock.json
>> ls -l .local/share/nvim/lsp_servers/sumneko_lua
i-rw-rw-r-- 1 testuser testuser 1082 Jan 13 10:51 '[Content_Types].xml'
drwxr-xr-x 6 testuser testuser 4096 Jan 14 15:55  extension
-rw-rw-r-- 1 testuser testuser 2591 Jan 13 10:51  extension.vsixmanifest
-rw-r--r-- 1 testuser testuser  349 Jan 14 15:55  nvim-lsp-installer-receipt.json
```

To reproduce issue run above commands with the nvim data directory as a mounted volume.
```bash
$ docker run --rm -ti -v "${PWD}/nvim-test:/home/testuser/.local/" nvim-test bash
>> nvim   # auto install packer
:q
>> nvim
:PackerInstall   # install packages
:q
>> nvim
:LspInstallInfo   # verify that pyright sumneko_lua are installing
:q
>> ls -l .local/share/nvim/lsp_servers/python
-rw-r--r-- 1 testuser testuser 188 Jan 14 15:38 nvim-lsp-installer-receipt.json
drwxr-xr-x 6 testuser testuser 192 Jan 14 15:38 pyright.tmp

>> ls -l .local/share/nvim/lsp_servers/sumneko_lua
-rw-r--r-- 1 testuser testuser 349 Jan 14 15:38 nvim-lsp-installer-receipt.json
drwxr-xr-x 5 testuser testuser 160 Jan 14 15:38 sumneko_lua.tmp
```
