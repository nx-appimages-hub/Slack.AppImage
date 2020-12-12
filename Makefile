# Copyright 2020 Alex Woroschilow (alex.woroschilow@gmail.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
PWD:=$(shell pwd)


all:
	mkdir 	--parents $(PWD)/build/Boilerplate.AppDir/slack
	apprepo --destination=$(PWD)/build appdir boilerplate libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0 libffi7
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}:$${APPDIR}/slack' 					>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'export LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}' 								>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'UUC_VALUE=`cat /proc/sys/kernel/unprivileged_userns_clone 2> /dev/null`' 	>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo ''										 									>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '' 																		>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo 'if [ -z "$${UUC_VALUE}" ]' 												>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '    then' 																>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '        exec $${APPDIR}/slack/slack --no-sandbox "$${@}"' 				>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '    else' 																>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '        exec $${APPDIR}/slack/slack "$${@}"' 								>> $(PWD)/build/Boilerplate.AppDir/AppRun
	echo '    fi' 																	>> $(PWD)/build/Boilerplate.AppDir/AppRun

	wget --output-document=$(PWD)/build/build.deb https://downloads.slack-edge.com/linux_releases/slack-desktop-4.4.2-amd64.deb
	dpkg -x $(PWD)/build/build.deb $(PWD)/build

	cp --force --recursive $(PWD)/build/usr/lib/slack/* $(PWD)/build/Boilerplate.AppDir/slack
	cp --force --recursive $(PWD)/build/usr/lib64/* $(PWD)/build/Boilerplate.AppDir/lib64			| true
	cp --force --recursive $(PWD)/build/usr/lib/* $(PWD)/build/Boilerplate.AppDir/lib64				| true
	cp --force --recursive $(PWD)/build/usr/share/* $(PWD)/build/Boilerplate.AppDir/share			| true

	rm --force $(PWD)/build/Boilerplate.AppDir/lib64/slack					|| true
	rm --force $(PWD)/build/Boilerplate.AppDir/*.desktop					|| true
	cp --force $(PWD)/AppDir/*.desktop $(PWD)/build/Boilerplate.AppDir/
	cp --force $(PWD)/AppDir/*.png $(PWD)/build/Boilerplate.AppDir/ 		|| true
	cp --force $(PWD)/AppDir/*.svg $(PWD)/build/Boilerplate.AppDir/ 		|| true

	export ARCH=x86_64 && $(PWD)/bin/appimagetool.AppImage $(PWD)/build/AppDir $(PWD)/Slack.AppImage
	chmod +x $(PWD)/Slack.AppImage

clean:
	rm -rf $(PWD)/build
