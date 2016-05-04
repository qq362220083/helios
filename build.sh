#!/bin/bash

SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
pushd . > /dev/null
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null

mono $SCRIPT_PATH/.nuget/NuGet.exe install FAKE -OutputDirectory $SCRIPT_PATH/packages -ExcludeVersion -Version 4.9.1
mono $SCRIPT_PATH/.nuget/NuGet.exe install NBench.Runner -OutputDirectory $SCRIPT_PATH/packages -ExcludeVersion -Version 0.2.2
mono $SCRIPT_PATH/.nuget/nuget.exe install xunit.runners -OutputDirectory $SCRIPT_PATH/packages/FAKE -ExcludeVersion -Version 2.1.0

if ! [ -e $SCRIPT_PATH/packages/SourceLink.Fake/tools/SourceLink.fsx ] ; then
	mono $SCRIPT_PATH/.nuget/NuGet.exe install SourceLink.Fake -OutputDirectory $SCRIPT_PATH/packages -ExcludeVersion

fi

export encoding=utf-8

mono $SCRIPT_PATH/packages/FAKE/tools/FAKE.exe build.fsx "$@"
