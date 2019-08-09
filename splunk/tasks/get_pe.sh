#!/bin/bash -x

# PT_key_file_path
# PT_dest

function is_ok
{
    ret=$1
    error=$2

    if [[ ${ret} -ne 0 ]];then
        echo -e "[${error}] failed with code [$ret]"
        exit 2
    fi
}

#!/bin/bash

PE_RELEASE=2019.0
PE_LATEST=$(curl http://enterprise.delivery.puppetlabs.net/${PE_RELEASE}/ci-ready/LATEST)
PE_FILE_NAME=puppet-enterprise-${PE_LATEST}-el-7-x86_64
TAR_FILE=${PE_FILE_NAME}.tar
DOWNLOAD_URL=http://enterprise.delivery.puppetlabs.net/${PE_RELEASE}/ci-ready/${TAR_FILE}

if [ ! -d packages ];then
    mkdir packages
fi

if [ ! -f "${TAR_FILE}"];then
    ## Download PE
    curl -o ${TAR_FILE} packages/${DOWNLOAD_URL}
    is_ok $? “Error: wget failed to download [${DOWNLOAD_URL}]”
fi

scp -i ${PT_key_file_path} -oStrictHostKeyChecking=no packages/${TAR_FILE} ${PT_dest}: > /dev/null 2>&1
is_ok $? “Error: failed to upload [${TAR_FILE}]”

echo -n "${TAR_FILE}"

