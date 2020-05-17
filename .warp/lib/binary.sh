#!/bin/bash

WARP_BINARY_FILE=$1

touch $WARP_BINARY_FILE
chmod 775 $WARP_BINARY_FILE
echo "#!/bin/bash +x" >> $WARP_BINARY_FILE
echo "" >> $WARP_BINARY_FILE
echo "bash ./warp \"\$@\"" >> $WARP_BINARY_FILE