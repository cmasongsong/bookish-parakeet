#!/bin/sh
#
# Shell script to excute Command Line Interface
SRCDIR=`pwd`
OSDIR=${SRCDIR}
COMDIR=${SRCDIR}


if [ ! -r /usr/bin/java ]; then
  echo "No Java install, please install version 1.5 above java runtime machine."
  exit;
fi

if [ -r /usr/bin/java ]; then
`java -version > /tmp/.java_version 2>&1`
#echo $TEMP
JAVA_VERSION=`grep "java version" /tmp/.java_version | cut -d ' ' -f 3 | cut -d '"' -f 2 | cut -d "." -f 2`
fi
if [ $JAVA_VERSION -lt 5 ]; then
  echo "Please install version 1.5 above java runtime machine."
  exit;
fi

OSNAME_P=`uname -p`
OSNAME_A=`uname -a`
OSNAME_NULL=`uname`
OSKERNEL=`uname -m`


if [ "$OSNAME_P" = "sparc" ]; then 
  LD_LIBRARY_PATH="nix/sol.spc.64/"

elif [ "$OSNAME_P" = "i386" ]; then
  LD_LIBRARY_PATH="nix/sol.x86/"

elif [ "$OSNAME_NULL" = "Linux" ]; then
	if [ "$OSKERNEL" = "x86_64" ]; then
		LD_LIBRARY_PATH="nix/linux.x64/"
	else
  	LD_LIBRARY_PATH="nix/linux.x86/"
  fi
fi

export LD_LIBRARY_PATH  

AgentExist=`ps -o pid -o args | grep -vin "grep" | grep -c newAgent.jar`

if [ $AgentExist -ge 1 ]; then
        echo "Agent already exists."
else
        echo "starting In-band Agent"
  if [ "$OSKERNEL" = "x86_64" ]; then
		java -Djava.compiler="" -cp nix/linux.x64/log4j.jar:nix/linux.x64/newAgent.jar newagent.Agent > /dev/null 2>&1 &
	else
		java -Djava.compiler="" -cp nix/log4j.jar:nix/newAgent.jar newagent.Agent > /dev/null 2>&1 &
	fi

	if [ `echo $?`=0 ];
	then
		echo "Agent started." 
	else
		echo "Start Agent failed."
	fi
fi


if [ "$1" = "" ] ; then
java -Djava.compiler="" -jar raidcmd_ESDS10.jar 
elif [ ! "$1" = "" ]; then
java -Djava.compiler="" -jar raidcmd_ESDS10.jar $1 $2 $3 $4 $5 $6 $7 $8 $9
fi

exit;
